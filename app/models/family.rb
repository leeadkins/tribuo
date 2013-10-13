class Family < ActiveRecord::Base

  has_many :children, :dependent => :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :family_size, presence: true, numericality: true
  validates :children_size, presence: true, numericality: true


  accepts_nested_attributes_for :children,
    :allow_destroy => true,
    :reject_if     => :all_blank

end
