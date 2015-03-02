class AlternativeName < ActiveRecord::Base
  belongs_to :person

  validates :person, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
end
