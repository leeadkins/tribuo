class Family < ActiveRecord::Base

  default_scope { order('last_name ASC, first_name ASC') } 

  has_many :children, :dependent => :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :family_size, presence: true, numericality: true
  validates :children_size, presence: true, numericality: true


  accepts_nested_attributes_for :children,
    :allow_destroy => true,
    :reject_if     => proc { |attributes| attributes['name'].blank? || attributes['age'].blank? }



  def self.generate_pdfs
    sd = "MARION COUNTY SHERIFF'S DEPARTMENT"
    pdf=FPDF.new('p','mm','letter')
    pdf.SetLineWidth(2)
    pdf.AddPage
    @switcher = 1;
    @families = Family.find(:all, :order => 'box ASC')
    for family in @families
      # Some quick processing the aid in the generation of these box labels
      if family.box == nil
        boxy = " "
      else
        boxy = family.box.to_s
      end
      if family.children.size == 0
        toys = "No"
      else
        toys = family.children.size.to_s
      end
      #That's all...
      if @switcher == 1
        pdf.SetFont('Arial','B',16)
        pdf.TextCenter(10,sd)
        pdf.SetFont('Arial','',30)
        pdf.TextRight(30,"Size : " + family.family_size.to_s)
        pdf.SetFont('Arial','',20)  
        pdf.TextLeft(30,"Name:    " + family.first_name.capitalize + " " + family.last_name.capitalize)
        pdf.TextLeft(40,"Address: " + family.address)
        pdf.TextLeft(50,"Phone:   " + family.phone)
        pdf.TextLeft(60, (!!family.pickup).to_s)
        pdf.SetFont('Arial','BI', 205)
        pdf.TextCenter(120,boxy)
        pdf.SetFont('Arial','',30)
        pdf.TextRight(125,"Toys: " + toys)
        # pdf.Image('public/images/tribtick.jpg',5,115,60)
        @switcher = 2
      else
        pdf.SetFont('Arial', 'B', 16)       
        pdf.TextCenter(150,sd)
        pdf.SetFont('Arial', '', 30)
        pdf.TextRight(170,"Size : "+ family.family_size.to_s)
        pdf.SetFont('Arial','',20)
        pdf.TextLeft(170,"Name:    " + family.first_name.capitalize + " " + family.last_name.capitalize)
        pdf.TextLeft(180,"Address: " + family.address)
        pdf.TextLeft(190,"Phone:   " + family.phone)
        pdf.TextLeft(200, (!!family.pickup).to_s)
        pdf.SetFont('Arial','BI', 205)
        pdf.TextCenter(260,boxy)
        pdf.SetFont('Arial','',30)
        pdf.TextRight(265, "Toys: " + toys)
        # pdf.Image('public/images/tribtick.jpg',5,255,60)
        pdf.Line(0,140,215,140)
        pdf.AddPage
        @switcher = 1
      end
    end
    pdf.Output
  end

end
