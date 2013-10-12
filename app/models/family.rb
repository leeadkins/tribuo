class Family < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :family_size, presence: true, numericality: true
  validates :children_size, presence: true, numericality: true

end
