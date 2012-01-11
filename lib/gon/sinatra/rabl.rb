require 'rabl'

module Gon
  module Sinatra
    module Rabl
      class << self
        def parse_rabl(rabl_path, controller)
          source = File.read(rabl_path)
          rabl_engine = ::Rabl::Engine.new(source, :format => 'json')
          output = rabl_engine.render(controller, {})
          ::Rabl.configuration.json_engine.decode(output)
        end
      end
    end
  end
end
