require 'rails_helper'
require 'pp'

RSpec.describe SourcesController, :type => :controller do

  fixtures :all

  describe "list sources" do

    context "when there are no sources to be found" do
      it "should return an empty sources array" do
        sources = Source.all
        sources.each do |source|
          source.delete
        end

        get :index
        expect(json['sources'].empty?).to be_truthy
      end
    end

    context "when there is a list of sources to be found" do
      it "should return that list of sources" do
        s1 = sources(:xkonto)
        s2 = sources(:orcid)
        get :index
        expect(json['sources'][0]['id']).to eq(s1.id)
        expect(json['sources'][0]['name']).to eq(s1.name)
        expect(json['sources'][1]['id']).to eq(s2.id)
        expect(json['sources'][1]['name']).to eq(s2.name)
      end
    end
  end

  describe "create source" do

    context "when given sufficient parameters" do
      it "should create source and return representation" do
        s1 = Source.new
        s1.name = 'danishjohnnyid'
        post :create, source: {name: s1.name}
        expect(response.status).to eq 201
        expect(json['error']).to be nil
        expect(json['source']).not_to be nil
        expect(json['source']['id']).not_to be nil
        expect(json['source']['name']).to eq(s1.name)
      end
    end

    context "when required parameters are missing" do
      it "should return an error" do
        s1 = Source.new
        post :create, source: {}
        expect(response.status).to eq 422
        expect(json['error']).not_to be nil
        expect(json['source']).to be nil
      end
    end
  end

  describe "retrieve source" do

    context "when the source exist" do
      it "should return that source" do
        s1 = sources(:xkonto)
        get :show, id: s1.id
        expect(response.status).to eq(200)
        expect(json['error']).to be nil
        expect(json['source']).not_to be nil
        expect(json['source']['id']).to eq(s1.id)
        expect(json['source']['name']).to eq(s1.name)
      end
    end

    context "when the source does not exist" do
      it "should return error" do
        get :show, id: 999999999
        expect(response.status).to eq(404)
        expect(json['error']).not_to be nil
        expect(json['source']).to be nil
      end
    end
  end

  describe "update source" do

    context "when properties are changed" do
      it "should update source and return json with new state of the source" do
        s1 = sources(:xkonto)
        new_name = 'xyzkonto'
        post :update, id: s1.id, source: {name: new_name}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['source']).not_to be nil
        expect(json['source']['id']).to eq(s1.id)
        expect(json['source']['name']).to eq(new_name)
      end
      it "should ignore the created_at param" do
        s1 = sources(:xkonto)
        new_name = 'xyzkonto'
        new_created_at = DateTime.parse('1999-12-31 23:59:59')
        put :update, id: 1, source: {created_at: new_created_at, name: new_name}
        expect(response.status).to eq 200
        expect(json['error']).to be nil
        expect(json['source']).not_to be nil
        expect((DateTime.parse(json['source']['created_at'])).year).to eq(Time.now().year)
        expect(json['source']['name']).to eq(new_name)
      end
    end

    context "when required property is deleted" do
      it "should return an error" do
        s1 = sources(:xkonto)
        new_name = ''
        put :update, id: s1.id, source: {name: new_name}
        expect(response.status).to eq 422
        expect(json['error']).not_to be nil
        expect(json['source']).to be nil
        expect(json['error']['msg']).to eq("Could not update the source")
      end
    end

    context "when source is not found" do
      it "should return an error" do
        new_name = 'danishjohnnyid'
        new_label = 'Danish Johnny ID'
        put :update, id: 999999999, source: {name: new_name, label: new_label}
        expect(response.status).to eq 404
        expect(json['error']).not_to be nil
        expect(json['source']).to be nil
        expect(json['error']['msg']).to eq("Could not find the source to update")
      end
    end
  end

end
