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
    Sinatra::Application.instance_methods.map(&:to_s).include?('include_gon').should == true

    # TODO: Make it work
    base = Sinatra::Base.new!
    base.include_gon.should == "<script>window.gon = {};" +
                                 "gon.int=1;" +
                               "</script>"
  end

  it 'returns exception if try to set public method as variable' do
    Gon::Sinatra.clear
    lambda { Gon::Sinatra.all_variables = 123 }.should raise_error
  end

  it 'should be threadsafe' do
    instance1 = Sinatra::Base.new!
    instance2 = Sinatra::Base.new!

    instance1.gon.test = "foo"
    instance2.gon.test = "bar"
    instance1.gon.test.should == "foo"
  end


  it 'render json from rabl template' do
    Gon::Sinatra.clear
    @objects = [1,2]
    Gon::Sinatra.rabl 'spec/test_data/sample.rabl', :instance => self
    Gon::Sinatra.objects.length.should == 2
  end

  def request
    @request ||= double 'request', :env => {}
  end

end
