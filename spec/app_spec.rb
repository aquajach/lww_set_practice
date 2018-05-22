require 'rack/test'
require 'json'
require_relative '../app'
require_relative '../lww_set_repo'
require_relative '../db/client'

describe App do
  include Rack::Test::Methods

  let(:app) { App.new }

  before(:each) do
    DB::Client.clean('elements')
  end

  describe '#create' do
    it 'creates a new LWW set' do
      post '/lwwsets', {key: 'new', data_set: %w[1 2 3]}.to_json
      expect(LwwSetRepo.find('new')).to eq %w[1 2 3]
      get '/lwwset/new/'
      expect(JSON.parse(last_response.body)).to eq %w[1 2 3]
    end
  end

  describe '#insert' do
    it 'inserts an element to an existing LWW set' do
      LwwSetRepo.create('new', %w[a b c])
      put '/lwwset/new/insert', {data: 'd'}.to_json
      expect(LwwSetRepo.find('new')).to eq %w[a b c d]
      get '/lwwset/new/'
      expect(JSON.parse(last_response.body)).to eq %w[a b c d]
    end
  end

  describe '#remove' do
    it 'removes an element from an existing LWW set' do
      LwwSetRepo.create('new', %w[a b c])
      put '/lwwset/new/remove', {data: 'b'}.to_json
      expect(LwwSetRepo.find('new')).to eq %w[a c]
      get '/lwwset/new/'
      expect(JSON.parse(last_response.body)).to eq %w[a c]
    end
  end
end