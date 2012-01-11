
module Gon
  module Sinatra
    class Store
      attr_accessor :request

      def initialize(variables)
        @env = variables
      end

      def all_variables
        @env
      end

      def clear
        @env.clear
      end

      def method_missing(m, *args, &block)
        if ( m.to_s =~ /=$/ )
          if public_methods.include? m.to_s[0..-2].to_sym
            raise "You can't use Gon public methods for storing data"
          end
          set_variable(m.to_s.delete('='), args[0])
        else
          get_variable(m.to_s)
        end
      end

      def get_variable(name)
        @env[name]
      end
      alias :get :get_variable

      def set_variable(name, value)
        @env[name] = value
      end
      alias :set :set_variable

      def rabl(view_path, options = {})
        raise Exception.new("You must require rabl and register Gon::Sinatra::Rabl to use rabl") unless defined? Rabl

        unless options[:instance]
          raise ArgumentError.new("You should pass :instance in options: :instance => self")
        end

        rabl_data = Gon::Sinatra::Rabl.parse_rabl(view_path, options[:instance])

        if options[:as]
          set_variable(options[:as].to_s, rabl_data)
        elsif rabl_data.is_a? Hash
          rabl_data.each do |key, value|
            set_variable(key, value)
          end
        else
          set_variable('rabl', rabl_data)
        end
      end

      def jbuilder(view_path, options = {})
        raise NoMethodError.new("Not available for sinatra")
      end
    end
  end
end
