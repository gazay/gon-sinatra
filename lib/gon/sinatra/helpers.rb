require 'json'

module Gon
  module Sinatra
    module Helpers
      def include_gon(options = {})
        if Gon::Sinatra.request_env && Gon::Sinatra.all_variables.present?
          data = Gon::Sinatra.all_variables
          namespace = options[:namespace] || 'gon'
          script = "<script>window." + namespace + " = {};"
          unless options[:camel_case]
            data.each do |key, val|
              script += namespace + "." + key.to_s + '=' + val.to_json + ";"
            end
          else
            data.each do |key, val|
              script += namespace + "." + key.to_s.camelize(:lower) + '=' + val.to_json + ";"
            end
          end
          script += "</script>"
          script
        else
          ""
        end
      end
    end

    module GonHelpers
      def gon
        if !Gon::Sinatra.request_env || Gon::Sinatra.request != request.object_id
          Gon::Sinatra.request = request.object_id
          Gon::Sinatra.request_env = request.env
        end
        Gon::Sinatra
      end
    end
  end
end

Sinatra::Base.helpers Gon::Sinatra::GonHelpers, Gon::Sinatra::Helpers
