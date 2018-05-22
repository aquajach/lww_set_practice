require_relative 'db/client'
require_relative './lww_set'

class LwwSetRepo
  def self.find(id)
    set = LwwSet.new
    elements = DB::Client.find('elements', {set_id: id})

    elements.each do |element|
      set.send(element['set_type'], element['data'])
    end
    set.elements.to_a
  end

  def self.create(key, data_set)
    values = data_set.map do |element|
      [key, 'add', element, Time.now.to_i]
    end
    DB::Client.insert('elements', %w[set_id set_type data timestamp], values)
  end

  def self.add(key, data)
    self.create(key, [data])
  end

  def self.remove(key, data)
    DB::Client.insert('elements', %w[set_id set_type data timestamp], [[key, 'remove', data, Time.now.to_i]])
  end
end