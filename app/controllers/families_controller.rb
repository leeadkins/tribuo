class FamiliesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_family, only: [:show, :edit, :update, :destroy, :toggle_flag]

  # GET /families
  # GET /families.json
  def index
    @search = Family.search(params[:q])
    @families = @search.result(distinct: true)
    respond_to do |format|
      format.html
      format.pdf { send_data Family.to_pdf, :filename => "families_#{Time.now.to_s(:long).parameterize.underscore}.pdf", :type => "application/pdf"}
    end
  end

  # GET /families/1
  # GET /families/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf { send_data @family.to_pdf, :filename => "#{@family.first_name}_#{@family.last_name}_#{Time.now.to_s(:long).parameterize.underscore}.pdf", :type => "application.pdf"}
    end
  end

  # GET /families/new
  def new
    @family = Family.new
  end

  def toggle_flag

    @family.flag = !@family.flag
    @family.save

    respond_to do |format|
      format.js
    end
  end

  # GET /families/1/edit
  def edit
  end

  # POST /families
  # POST /families.json
  def create
    @family = Family.new(family_params)

    respond_to do |format|
      if @family.save
        format.html { redirect_to @family, notice: 'Family was successfully created.' }
        format.json { render action: 'show', status: :created, location: @family }
      else
        format.html { render action: 'new' }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /families/1
  # PATCH/PUT /families/1.json
  def update
    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, notice: 'Family was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.json
  def destroy
    @family.destroy
    respond_to do |format|
      format.html { redirect_to families_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:first_name, :last_name, :phone, :address, :directions, :family_size, :children_size, :food_only, :flag, :delivery, children_attributes: [:id, :name, :age, :gender, :age_type])
    end
end
