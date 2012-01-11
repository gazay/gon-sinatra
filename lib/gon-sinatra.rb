require 'sinatra'
require 'gon/sinatra/store'
require 'gon/sinatra/helpers'

module Gon
  module Sinatra
    def self.registered(base)
      base.helpers(Gon::Sinatra::GonHelpers, Gon::Sinatra::Helpers)
    end

    module Rabl
      def self.registered(base)
        require 'rabl'
        require 'gon/sinatra/rabl'
      end
    end
  end
end
