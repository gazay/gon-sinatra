require 'rabl'
require 'tilt'

module Gon
  module Sinatra
    module Rabl
      class << self
        def cache
          @cache ||= Tilt::Cache.new
        end

        def parse_rabl(rabl_path, controller)
          source = cache.fetch(rabl_path) do
            File.read(rabl_path)
          end

          rabl_engine = ::Rabl::Engine.new(source, :format => 'json')
          output = rabl_engine.render(controller, {})
          ::Rabl.configuration.json_engine.parse(output)
        end
      end
    end
  end
end
