class Source < ActiveRecord::Base
  has_many :identifiers
  has_many :people, :through => :identifiers
  validates :name, :presence => true
  validates :label, :presence => true
end
