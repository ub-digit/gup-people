class Identifier < ActiveRecord::Base
  belongs_to :person
  belongs_to :source
  validates :value, :presence => true
end
