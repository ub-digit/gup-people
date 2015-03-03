class Person < ActiveRecord::Base
  has_many :names
  has_many :identifiers
  has_many :sources, :through => :identifiers

  validates :last_name, :presence => true

  def as_json()
    {
      id: id,
      year_of_birth: year_of_birth,
      first_name: first_name,
      last_name: last_name,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
