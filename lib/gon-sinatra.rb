require 'sinatra'
require 'gon/sinatra/store'
require 'gon/sinatra/helpers'
require 'gon/sinatra/rabl'

module Gon
  module Sinatra
    def self.registered(base)
      base.helpers(Gon::Sinatra::GonHelpers, Gon::Sinatra::Helpers)
    end
  end
end
