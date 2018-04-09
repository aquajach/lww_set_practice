require 'rspec'
require 'timecop'
require_relative './lww_set'
require_relative './element'

describe LwwSet do
  describe '#initialize' do
    it 'starts with empty set' do
      set = LwwSet.new
      expect(set.add_set).to eql(Set[])
      expect(set.remove_set).to eql(Set[])
      expect(set.elements).to eql(Set[])
    end
  end

  describe '#add' do
    it 'inserts to add set' do
      Timecop.freeze(Time.new(2018))
      set = LwwSet.new
      set.add(1)
      expect(set.add_set).to eql(Set.new([Element.new(1, Time.new(2018))]))
      expect(set.elements).to eql(Set[1])
    end

    it 'is idempotent' do
      set = LwwSet.new
      set.add(1)
      Timecop.freeze(Time.new(2019))
      set.add(1)
      expect(set.elements).to eql(Set[1])
    end
  end

  describe '#remove' do
    it 'inserts to remove set' do
      set = LwwSet.new
      set.add(1)
      Timecop.freeze(Time.new(2019))
      set.remove(1)
      expect(set.remove_set).to eql(Set.new([Element.new(1, Time.new(2019))]))
      expect(set.elements).to eql(Set[])
    end

    it 'returns empty set with add' do
      set = LwwSet.new
      set.remove(1)
      expect(set.elements).to eql(Set[])
    end
  end

  describe '#elements' do
    it 'has bias on remove' do
      set = LwwSet.new
      set.add(1)
      set.add(1)
      Timecop.freeze
      set.remove(2)
      set.add(2)
      expect(set.elements).to eql(Set[1])
    end

    it 'runs on a more complex set' do
      set = populate_lww_set(1, 2, 3, 2, 3, [-4, 1], -3, [5, -5, -1], 6, 10)
      expect(set.elements).to eql(Set[2, 6, 10])
    end
  end

  def populate_lww_set(*data_set)
    set = LwwSet.new
    data_set.each do |element|
      if element.is_a?(Array)
        Timecop.freeze do
          element.each do |e|
            e > 0 ? set.add(e) : set.remove(-e)
          end
        end
      else
        element > 0 ? set.add(element) : set.remove(-element)
      end
    end
    set
  end

  after do
    Timecop.return
  end
end