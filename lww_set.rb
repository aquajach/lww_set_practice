require 'set'
require_relative './element'

class LwwSet
  BIAS = :remove_set
  attr_accessor :add_set, :remove_set

  def initialize
    @add_set = Set[]
    @remove_set = Set[]
  end

  def add(data)
    add_set << Element.new(data, Time.now)
  end

  def remove(data)
    remove_set << Element.new(data, Time.now)
  end

  def elements
    Set.new(add_set.select do |ae|
      !remove_set.find do |re|
        re.data == ae.data &&
            (BIAS == :remove_set ?
                 re.timestamp >= ae.timestamp :
                 re.timestamp > ae.timestamp)
      end
    end.map(&:data))
  end
end