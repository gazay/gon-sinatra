module Gon
  module Sinatra
    module Helpers
      def self.included base
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
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
            script.html_safe
          else
            ""
          end
        end
      end
    end

    module GonHelpers
      def self.included base
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
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
end

Sinatra::Helpers.send :include, Gon::Sinatra::Helpers
Sinatra::Base.send :include, Gon::Sinatra::GonHelpers
