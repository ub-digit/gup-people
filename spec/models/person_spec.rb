require 'rails_helper'

RSpec.describe Person, :type => :model do
  fixtures :people

  describe "create person" do
    context "when given data is valid" do
      it "should create person" do
        p1 = people(:person_one)
        p1.first_name = "Newfirstname"
        p1.save!
        expect(p1.first_name).to eq("Newfirstname")
      end
    end
    context "when first name is blank" do
      it "should not create person" do
        p1 = people(:person_one)
        old_name = p1.first_name
        p1.first_name = ""
        expect(p1.valid?).to be_falsey
      end
    end
    context "when last name is blank" do
      it "should not create person" do
        p1 = people(:person_one)
        old_name = p1.last_name
        p1.last_name = ""
        expect(p1.valid?).to be_falsey
      end
    end
    context "when year of birth is blank" do
      it "should not create person" do
        p1 = people(:person_one)
        old_date = p1.year_of_birth
        p1.year_of_birth = nil
        expect(p1.valid?).to be_falsey
      end
    end
  end

end
