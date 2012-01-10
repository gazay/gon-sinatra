# gon_spec_rb
require 'gon-sinatra'

describe Gon::Sinatra, '#all_variables' do 

  before(:each) do
    Gon::Sinatra.request_env = {}
  end

  it 'returns all variables in hash' do
    Gon::Sinatra.a = 1
    Gon::Sinatra.b = 2
    Gon::Sinatra.c = Gon::Sinatra.a + Gon::Sinatra.b
    Gon::Sinatra.c.should == 3
    Gon::Sinatra.all_variables.should == {'a' => 1, 'b' => 2, 'c' => 3}
  end

  it 'supports all data types' do
    Gon::Sinatra.clear
    Gon::Sinatra.int = 1
    Gon::Sinatra.float = 1.1
    Gon::Sinatra.string = 'string'
    Gon::Sinatra.array = [ 1, 'string' ]
    Gon::Sinatra.hash_var = { :a => 1, :b => '2'}
    Gon::Sinatra.hash_w_array = { :a => [ 2, 3 ] }
    Gon::Sinatra.klass = Hash
  end

  it 'output as js correct' do
    Gon::Sinatra.clear
    Gon::Sinatra.int = 1
    Sinatra::Helpers.instance_methods.map(&:to_s).include?('include_gon').should == true
    base = Sinatra::Base.new
    base.include_gon.should == "<script>window.gon = {};" +
                                 "gon.int=1;" +
                               "</script>"
  end

  it 'returns exception if try to set public method as variable' do
    Gon::Sinatra.clear
    lambda { Gon::Sinatra.all_variables = 123 }.should raise_error
  end

  it 'render json from rabl template' do
    Gon::Sinatra.clear
    controller = ActionController::Base.new
    objects = [1,2]
    controller.instance_variable_set('@objects', objects)
    Gon::Sinatra.rabl 'spec/test_data/sample.rabl', :controller => controller
    Gon::Sinatra.objects.length.should == 2
  end

  def request
    @request ||= double 'request', :env => {}
  end

end
