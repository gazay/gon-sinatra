require 'json'

module Gon
  module Sinatra
    module Helpers
      def include_gon(options = {})
        if gon.all_variables.present?
          data = gon.all_variables
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
        env["gon"] ||= Gon::Sinatra::Store.new({})
        @gon = env["gon"]
      end
    end
  end
end