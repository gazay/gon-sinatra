# gon_spec_rb
require 'gon-sinatra'

class App < Sinatra::Base
  register Gon::Sinatra
end

describe Gon::Sinatra, '#all_variables' do 
  def app
    app = App.new!
    app.env = {}
    app
  end

  before(:each) do
    @gon = Gon::Sinatra::Store.new({})
  end

  it 'returns all variables in hash' do
    @gon.a = 1
    @gon.b = 2
    @gon.c = @gon.a + @gon.b
    @gon.c.should == 3
    @gon.all_variables.should == {'a' => 1, 'b' => 2, 'c' => 3}
  end

  it 'supports all data types' do
    @gon.clear
    @gon.int = 1
    @gon.float = 1.1
    @gon.string = 'string'
    @gon.array = [ 1, 'string' ]
    @gon.hash_var = { :a => 1, :b => '2'}
    @gon.hash_w_array = { :a => [ 2, 3 ] }
    @gon.klass = Hash
  end

  it 'output as js correct' do
    instance = app

    instance.gon.int = 1
    instance.methods.map(&:to_s).include?('include_gon').should == true

    # TODO: Make it work
    instance.include_gon.should == "<script>window.gon = {};" +
                                     "gon.int=1;" +
                                   "</script>"
  end

  it 'returns exception if try to set public method as variable' do
    @gon.clear
    lambda { @gon.all_variables = 123 }.should raise_error
  end

  it 'should be threadsafe' do
    instance1 = app()
    instance2 = app()

    instance1.gon.test = "foo"
    instance2.gon.test = "bar"
    instance1.gon.test.should == "foo"
  end

  it 'render json from rabl template' do
    @gon.clear
    @objects = [1,2]
    @gon.rabl 'spec/test_data/sample.rabl', :instance => self, :as => 'objects'
    @gon.objects.length.should == 2
  end

  def request
    @request ||= double 'request', :env => {}
  end

end
