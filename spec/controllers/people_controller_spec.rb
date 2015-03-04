require 'rails_helper'
require 'pp'

RSpec.describe PeopleController, :type => :controller do

  fixtures :all

  describe "list all people" do
    context "when no people are to be found" do
      it "should return an empty people array" do
        # Clean the test database from people fixture data
        people = Person.all
        people.each do |person|
          person.delete
        end

        get :index
        pp json
        expect(json['people'].empty?).to be_truthy
      end
    end

    context "when there is a list of people to be found" do
      it "should return that list of people" do
        get :index
        pp json
        expect(json['people'][0]['id']).to eq(1)
        expect(json['people'][1]['first_name']).to eq('Otto')
        expect(json['people'][4]['year_of_birth']).to eq(1980)
      end
    end
  end

  describe "get one person" do
    context "when the specific person exist" do
      it "should return that person" do
        get :show, id: 1
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).to eq(1)
      end
    end

    context "when the person does not exist" do
      it "should return error" do
        get :show, id: 999999999
        expect(json['error']).not_to be nil
        expect(json['person']).to be nil
        expect(json['error']['code']).to eq(404)
        expect(json['error']['msg']).to eq("Not Found")
      end
    end
  end

  describe "create one person" do
    context "when all parameters are fine" do
      it "should create and return a representation for that created person" do
        first_name = 'Anders'
        last_name = 'Andersson'
        year_of_birth = 1970
        post :create, person: {first_name: first_name, last_name: last_name, year_of_birth: year_of_birth}
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq(first_name)
        expect(json['person']['last_name']).to eq(last_name)
        expect(json['person']['year_of_birth']).to eq(year_of_birth)
        expect(response.status).to eq 201
      end
      it "should produce no errors" do
        first_name = 'Anders'
        last_name = 'Andersson'
        year_of_birth = 1970
        post :create, person: {first_name: first_name, last_name: last_name, year_of_birth: year_of_birth}
        expect(json['error']).to be nil
      end
      it "should return the \"Created\" header" do
        first_name = 'Anders'
        last_name = 'Andersson'
        year_of_birth = 1970
        post :create, person: {first_name: first_name, last_name: last_name, year_of_birth: year_of_birth}
        expect(response.status).to eq 201
      end
    end

    context "when first name is missing" do
      it "should create and return a representation for that created person" do
        last_name = 'Andersson'
        year_of_birth = 1970
        post :create, person: {last_name: last_name, year_of_birth: year_of_birth}
        expect(response.status).to eq 201
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq(nil)
        expect(json['person']['last_name']).to eq(last_name)
        expect(json['person']['year_of_birth']).to eq(year_of_birth)
      end
    end

    context "when last name is missing" do
      it "should return an error" do
        first_name = 'Anders'
        year_of_birth = 1970
        post :create, person: {first_name: first_name, year_of_birth: year_of_birth}
        expect(response.status).to eq 400
        expect(json['error']).not_to be nil
        expect(json['person']).to be nil
        expect(json['error']['code']).to eq(400)
        expect(json['error']['msg']).to eq("Could not create the person")
      end
    end

    context "when year of birth is missing" do
      it "should create and return a representation for that created person" do
        first_name = 'Anders'
        last_name = 'Andersson'
        post :create, person: {first_name: first_name, last_name: last_name}
        expect(response.status).to eq 201
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq(first_name)
        expect(json['person']['last_name']).to eq(last_name)
        expect(json['person']['year_of_birth']).to eq(nil)
      end
    end
  end

  describe "update one person" do
    context "when all parameters change" do
      it "should cupdate person and return json with new state of the person" do
        first_name = 'Anders'
        last_name = 'Andersson'
        year_of_birth = 1970
        post :update, id: 1, person: {first_name: first_name, last_name: last_name, year_of_birth: year_of_birth}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq(first_name)
        expect(json['person']['last_name']).to eq(last_name)
        expect(json['person']['year_of_birth']).to eq(year_of_birth)
      end
    end
    context "when last name is changed" do
      it "should update person and return person with the new last name" do
        last_name = 'Andersson'
        post :update, id: 1, person: {last_name: last_name}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq('Norbert')
        expect(json['person']['last_name']).to eq(last_name)
        expect(json['person']['year_of_birth']).to eq(1917)
      end
    end
    context "when last name is deleted" do
      it "should return an error" do
        last_name = ''
        put :update, id: 1, person: {last_name: last_name}
        expect(response.status).to eq 400
        expect(json['error']).not_to be nil
        expect(json['person']).to be nil
        expect(json['error']['code']).to eq(400)
        expect(json['error']['msg']).to eq("Could not update the person")
      end
    end
    context "when first name is deleted" do
      it "should update and return person with the new first name" do
        p1 = people(:person_one)
        first_name = ''
        put :update, id: 1, person: {first_name: first_name}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq(first_name)
        expect(json['person']['last_name']).to eq(p1.last_name)
        expect(json['person']['year_of_birth']).to eq(p1.year_of_birth)
      end
    end
    context "when year of birth is deleted" do
      it "should update and return person with the new year_of_birth" do
        p1 = people(:person_one)
        new_year_of_birth = nil
        put :update, id: 1, person: {year_of_birth: new_year_of_birth}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        expect(json['person']['id']).not_to be nil
        expect(json['person']['first_name']).to eq(p1.first_name)
        expect(json['person']['last_name']).to eq(p1.last_name)
        expect(json['person']['year_of_birth']).to eq(new_year_of_birth)
      end
    end
    context "when created at is tampered with" do
      it "should ignore the created_at param" do
        #created_at = DateTime.parse('1999-12-31 23:59:59')
        p1 = people(:person_one)
        new_created_at = Time.parse('1999-12-31 23:59:59.000Z')
        #Time.parse("2015-01-01 00:00:00.000000 -04:00")
        new_last_name = 'von Oben'
        put :update, id: p1.id, person: {created_at: new_created_at, last_name: new_last_name}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['person']).not_to be nil
        #expect((DateTime.parse(json['person']['created_at'])).year).to eq(Time.now().year)
        expect(json['person']['created_at']).to eq("2015-01-01T12:00:00.000Z")
        expect(json['person']['last_name']).to eq(new_last_name)

      end
    end
    context "when person is not found" do
      it "should return an error" do
        first_name = 'Norbert'
        last_name = 'Norbertsson'
        year_of_birth = 1917
        put :update, id: 999999999, person: {first_name: first_name, last_name: last_name}
        expect(response.status).to eq 404
        expect(json['error']).not_to be nil
        expect(json['person']).to be nil
        expect(json['error']['code']).to eq(404)
        expect(json['error']['msg']).to eq("Could not find the person to update")
      end
    end
  end

end
