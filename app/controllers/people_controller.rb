class PeopleController < ApplicationController

  # search first_name, last_name, alternative_names if xkonto or orcid or affiliated
  # search in xkonto
  # search in orcid
  def index
    search_term = params[:search_term] || ''

    @people = Person.all

    if search_term.present?
      st = search_term.downcase

      alternative_name_hit = AlternativeName.where(
        "(lower(first_name) LIKE ?)
        OR (lower(last_name) LIKE ?)",
        "%#{st}%", "%#{st}%"
      ).select(:person_id)

      source_hit = Identifier.where(
        "lower(value) LIKE ?",
        "%#{st}%"
      ).select(:person_id)

      @people = @people.where(
        "(((lower(first_name) LIKE ?)
          OR (lower(last_name) LIKE ?))
          AND (affiliated = true))
        OR (id IN (?) AND (affiliated = true))
        OR (id IN (?))",
        "%#{st}%",
        "%#{st}%",
        alternative_name_hit,
        source_hit
      )

      logger.info "SQL for search gup-people: #{@people.to_sql}"
    end

    @response[:people] = @people.as_json
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
      generate_error(422, "Could not create the person", obj.errors.messages)
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
      if obj.update(parameters.permit(:first_name, :last_name, :year_of_birth))
        @response[:person] = obj.as_json
      else
        generate_error(422, "Could not update the person", obj.errors.messages)
      end
    else
      generate_error(404, "Could not find the person to update")
    end
    render_json
  end

end
