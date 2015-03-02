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
    # If successful, render given status
    if @response[:error].nil?
      render json: @response, status: status
    else
      # If not successful, render with status from ErrorCodes module
      render json: @response, status: @response[:error][:code]
    end
  end

  # Generates an error object from code, message and error list
  def generate_error(http_code = 400, msg = "", error_list = nil)
    #Rack::Utils::HTTP_STATUS_CODES[242]
    if msg == ""
      msg = code_to_message(http_code)
    end
    @response = {}
    @response[:error] = {code: http_code, msg: msg, errors: error_list}
  end

  def code_to_message(http_code = 400)
    Rack::Utils::HTTP_STATUS_CODES[http_code]
  end

  def symbol_to_code(sumbol = :bad_request)
    Rack::Utils::SYMBOL_TO_STATUS_CODE
  end

  #def error_code(code = :bad_request) do
  #
  #end
end
