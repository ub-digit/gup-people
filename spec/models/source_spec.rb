require 'rails_helper'

RSpec.describe Source, :type => :model do
  #http://orcid.org/0000-0001-9711-5362
  describe "name is mandatory" do
    it { should validate_presence_of(:name) }
  end

  describe "name has to be unique" do
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe "name cannot contain only blanks" do
    it "should not contain blanks" do
      s = Source.new(name: ' ')
      s.save
      expect(s.valid?).to be_falsey
      expect(s.errors.messages[:name]).to eq(["can't be blank"])
    end
  end
end
