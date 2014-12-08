# gon_spec_rb
require 'gon-sinatra'

class App < Sinatra::Base
  register Gon::Sinatra
  register Gon::Sinatra::Rabl
end

describe Gon::Sinatra, '#all_variables' do
  def app
    app = App.new!
    app.env = {}
    app
  end

  before(:each) do
    @gon = Gon::Sinatra::Store.new({})
    Gon::Sinatra::Rabl.cache.clear
  end

  it 'returns all variables in hash' do
    @gon.a = 1
    @gon.b = 2
    @gon.c = @gon.a + @gon.b
    expect(@gon.c).to eq(3)
    expect(@gon.all_variables).to eq({'a' => 1, 'b' => 2, 'c' => 3})
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
    expect(instance.methods.map(&:to_s)).to include('include_gon')

    expect(instance.include_gon).to eq("<script>window.gon = {};" +
                                         "gon.int=1;" +
                                       "</script>")
  end

  it 'returns exception if try to set public method as variable' do
    @gon.clear
    expect { @gon.all_variables = 123 }.to raise_error
  end

  it 'should be threadsafe' do
    instance1 = app()
    instance2 = app()

    instance1.gon.test = "foo"
    instance2.gon.test = "bar"
    expect(instance1.gon.test).to eq("foo")
  end

  it 'renders json from rabl template' do
    @gon.clear
    @objects = [1,2]
    @gon.rabl 'spec/test_data/sample.rabl', :instance => self
    expect(@gon.objects.length).to eq(2)
  end

  it 'caches the rabl template' do
    @gon.clear
    @objects = [1,2]
    path = 'spec/test_data/sample.rabl'
    source = File.read(path)
    expect(File).to receive(:read).once.and_return(source)
    @gon.rabl path, :instance => self

    @gon.clear
    @objects = [1,2,3]
    @gon.rabl 'spec/test_data/sample.rabl', :instance => self
    expect(@gon.objects.length).to eq(3)
  end

  def request
    @request ||= double 'request', :env => {}
  end

end
