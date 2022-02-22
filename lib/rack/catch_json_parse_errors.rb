class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError => error
      if env['HTTP_ACCEPT'] =~ /application\/json/
        error_output = 'You have submitted an invalid JSON.'
        return [
          400, { 'Content-Type' => 'application/json' },
          [ { status: 400, error: error_output }.to_json ]
        ]
      else
        raise error
      end
    end
  end
end