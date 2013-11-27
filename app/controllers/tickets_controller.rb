class TicketsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def new_boxes
    Family.assign_new_numbers!
    redirect_to tickets_path, notice: 'New Box Numbers have been generated.'
  end

  def all_boxes
    Family.assign_all_numbers!
    redirect_to tickets_path, notice: 'All Box Numbers have been regenerated. Discard any existing printouts or master lists with the old numbers before continuing.'
  end
end
