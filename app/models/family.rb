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

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def readable_delivery
    self.delivery? ? 'Delivery' : 'Pickup'
  end

  def assign_number!
    # This isn't perfect. It will will simply find the largest box number and
    # assign the next number to this object.
    # Used in a pinch to give your last box a number.
  end

  def to_pdf(opts={})
    pdf = opts[:pdf].blank? ? FPDF.new('p', 'mm', 'letter') : opts[:pdf]
    half = opts[:half].blank? ? 0  : opts[:half]
    pdf.SetLineWidth(2)

    # What are we going to modify the positions by to go to the next page?
    modifier = half == 0 ? 0 : 140 
    
    if half == 0
      pdf.AddPage #Start a new page
    else
      pdf.Line(0, modifier, 215, modifier) # Draw a line on the current page.
    end

    # Do some setup of strings we're gonns user.
    if self.box == nil
      boxString = " "
    else
      boxString = self.box.to_s
    end

    if self.children.size == 0
      toyCountString = "No"
    else
      toyCountString = self.children.size.to_s
    end

    pdf.SetFont('Arial','B',16)
    pdf.TextCenter(10 + modifier, "MARION COUNTY SHERIFF'S DEPARTMENT")
    pdf.SetFont('Arial','',30)
    pdf.TextRight(30 + modifier,"Size : " + self.family_size.to_s)
    pdf.SetFont('Arial','',20)  
    pdf.TextLeft(30 + modifier, "Name:    " + self.first_name.capitalize + " " + self.last_name.capitalize)
    pdf.TextLeft(40 + modifier, "Address: " + self.address)
    pdf.TextLeft(50 + modifier, "Phone:   " + self.phone)
    pdf.TextLeft(60 + modifier, self.readable_delivery)
    pdf.SetFont('Arial','BI', 205)
    pdf.TextCenter(120 + modifier,boxString)
    pdf.SetFont('Arial','',30)
    pdf.TextRight(125 + modifier, "Toys: " + toyCountString)
    pdf.Image('public/single-logo.jpg',5,105 + modifier,30)

    # We weren't passed a PDF object to build off of, so render ourself
    if opts[:pdf].blank? 
      return pdf.Output
    end

  end

  def self.assign_all_numbers!
    to_update = Family.order('family_size DESC, children_size DESC, last_name ASC')
    current_box = 0
    to_update.each do |family|
      current_box = current_box + 1
      family.box = current_box
      family.save
    end
  end

  def self.assign_new_numbers!
    # First, get the new box number
    last_family = Family.where('box > 0').order('box DESC').first

    if last_family.nil?
      current_box = 0
    else
      current_box = last_family.box
    end

    to_update = Family.where(:box => nil).order('family_size DESC, children_size DESC, last_name ASC')

    to_update.each do |family|
      current_box = current_box + 1
      family.box = current_box
      family.save
    end
  end

  def self.to_pdf(opts={})
    pdf = FPDF.new('p', 'mm', 'letter')
    @families = self.order('box ASC')
    @families.each_with_index do |family, i|
      family.to_pdf pdf: pdf, half: i%2
    end
    pdf.Output
  end

end
