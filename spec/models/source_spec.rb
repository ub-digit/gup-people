require 'rails_helper'

RSpec.describe Source, :type => :model do
  #http://orcid.org/0000-0001-9711-5362
  describe "name is mandatory" do
    it { should validate_presence_of(:name) }
  end
end
