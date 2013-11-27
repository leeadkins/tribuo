class Child < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :family, :counter_cache => true

  def to_pdf(opts={})
    pdf = opts[:pdf].blank? ? FPDF.new('p', 'mm', 'letter') : opts[:pdf]
    half = opts[:half].blank? ? 0  : opts[:half]
    counter = opts[:counter].blank? ? nil  : opts[:counter]

    pdf.SetLineWidth(2)

    # What are we going to modify the positions by to go to the next page?
    modifier = half == 0 ? 0 : 140 
    
    if half == 0
      pdf.AddPage #Start a new page
    else
      pdf.Line(0, modifier, 215, modifier) # Draw a line on the current page.
    end

    # Do some setup of strings we're gonns user.
    if self.family.box == nil
      boxString = " "
    else
      boxString = self.family.box.to_s
    end

    age_type_abbr = self.age_type && self.age_type == 'month' ? 'm' : ''

    if self.gender == 'girl'
      info_string = "G / #{self.age}#{age_type_abbr}"
    else
      info_string = "B / #{self.age}#{age_type_abbr}"
    end

    pdf.SetFont('Arial','B',16)
    pdf.TextCenter(10 + modifier, "MARION COUNTY SHERIFF'S DEPARTMENT")
    pdf.SetFont('Arial','',30)
    if age_type_abbr == 'm'
      pdf.SetTextColor(255,0,0)
    else
      pdf.SetTextColor(0,0,0)
    end
    pdf.TextRight(30 + modifier,info_string)
    pdf.SetTextColor(0,0,0)
    pdf.SetFont('Arial','',60)
    pdf.TextCenter(35 + modifier, self.name.capitalize)
    pdf.SetFont('Arial','',20)
    pdf.TextCenter(50 + modifier, "Parent: #{self.family.full_name} ")
    pdf.SetFont('Arial','BI', 205)
    pdf.TextCenter(115 + modifier,boxString)
    pdf.SetFont('Arial','',30)
    if counter
      pdf.TextRight(130 + modifier, "Sack #{counter} of #{self.family.children.size.to_s}")
    end
    # pdf.Image('public/images/tribtick.jpg',5,115 + modifier,60)

    # We weren't passed a PDF object to build off of, so render ourself
    if opts[:pdf].blank? 
      return pdf.Output
    end

  end


  def self.to_pdf(opts={})
    pdf = FPDF.new('p', 'mm', 'letter')
    @children = self.includes(:family).order('families.box ASC, name ASC')
    # So here is the hacky thing this time.
    # We need to keep a counter for each family while iterating the children
    # so we can display "1 of 2" or whatever.
    current_id = -1
    child_counter = 0
    @children.each_with_index do |child, i|
      if current_id != child.family_id
        current_id = child.family_id
        child_counter = 1
      else
        child_counter = child_counter + 1
      end

      child.to_pdf pdf: pdf, half: i%2, counter: child_counter
    end
    pdf.Output
  end
end
