class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :setup

  # Setup global state for response
  def setup
    @response ||= {}
  end

  def render_json(status = 200)
    # If successful, render object as JSON
    if @response[:error].nil?
      render json: @response, status: status
    else
      # If not successful, render error as JSON
      render json: @response, status: @response[:error][:code]
    end
  end

  # Generates an error object from code, message and error list
  # If the msg parameter is not provided the HTTP_STATUS message will be used.
  # If no specific HTTP Coce is given then 400, Bad Request will be used.
  def generate_error(http_code = 400, msg = "", error_list = nil)

    if msg == ""
      msg = code_to_message(http_code)
    end
    @response = {}
    @response[:error] = {code: http_code, msg: msg, errors: error_list}
  end

  def code_to_message(http_code = 400)
    Rack::Utils::HTTP_STATUS_CODES[http_code]
  end

end
