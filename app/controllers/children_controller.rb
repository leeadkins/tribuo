class ChildrenController < ApplicationController
  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.pdf { send_data Child.to_pdf, :filename => "children_#{Time.now.to_s(:long).parameterize.underscore}.pdf", :type => "application/pdf" }
    end
  end
end
