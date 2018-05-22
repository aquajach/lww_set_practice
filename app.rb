require 'json'
require_relative './lww_set_repo'

class App
  def call(env)
    req = Rack::Request.new(env)

    body = req.body.length > 0 ? JSON.parse(req.body.read) : {}
    response = if req.post? && req.path_info == '/lwwsets'
                 create(body['key'], body['data_set'])
               elsif req.put? && req.path_info =~ /\/lwwset\/.+\/insert/
                 insert(key_from_path(req.path_info), body['data'])
               elsif req.put? && req.path_info =~ /\/lwwset\/.+\/remove/
                 remove(key_from_path(req.path_info), body['data'])
               elsif req.get? && req.path_info =~ /\/lwwset\/.+\/*/
                 show(key_from_path(req.path_info))
               end
    if response
      [200, {'Content-Type' => 'application/json'}, [response]]
    else
      [500, {'Content-Type' => 'application/json'}, ['Path not found']]
    end
  end

  private
  def create(key, data_set)
    LwwSetRepo.create(key, data_set)
    'Created'
  end

  def insert(key, new_data)
    LwwSetRepo.add(key, new_data)
    'Inserted'
  end

  def remove(key, existing_data)
    LwwSetRepo.remove(key, existing_data)
    'Removed'
  end

  def show(key)
    LwwSetRepo.find(key)
  end

  private

  def key_from_path(path)
    path.force_encoding('UTF-8')[/\/lwwset\/(.*)\//, 1]
  end
end