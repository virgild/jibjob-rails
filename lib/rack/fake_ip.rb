module Rack
  class FakeIP
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      if req.cookies["_ip_address"]
        env['REMOTE_ADDR'] = req.cookies["_ip_address"]
      end
      @app.call(env)
    end
  end
end