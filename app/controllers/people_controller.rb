class PeopleController < ApplicationController
  def index
    objs = Person.all

    @response[:people] = objs.as_json
    render_json
  end

  def create
    person_params = params[:person]
    parameters = ActionController::Parameters.new(person_params)
    obj = Person.new(parameters.permit(:first_name, :last_name, :year_of_birth))

    if obj.save
      url = url_for(controller: 'people', action: 'create', only_path: true)
      headers['location'] = "#{url}/#{obj.id}"
      @response[:person] = obj.as_json
    else
      generate_error(400, "Could not create the person", obj.errors.messages)
    end
    render_json(201)
  end

  def show
    id = params[:id]
    obj = Person.find_by id: id

    if obj
      @response[:person] = obj.as_json
    else
      generate_error(404)
    end
    render_json
  end

  def update
    obj_params = params[:person]
    parameters = ActionController::Parameters.new(obj_params)
    id = params[:id]
    obj = Person.find_by id: id

    if obj
      #obj.update_attributes(params[:person].to_hash)
      obj.update_attributes(parameters.permit(:first_name, :last_name, :year_of_birth))
      # TODO Put in some more code to check attributes in JSON
      # We dont want to change each and every attribute like created_by
      if obj.save
        @response[:person] = obj.as_json
      else
        generate_error(400, "Could not update the person", obj.errors.messages)
      end
    else
      generate_error(404, "Could not find the person to update")
    end
    render_json
  end
end
