require "sqlite3"

module DB
  def db
    db = SQLite3::Database.new "db/#{ENV['RACK_ENV']}.db"
    db.results_as_hash = true
    db
  end
  module_function :db

  class Client
    def self.insert(table, columns, data_set)
      fields = data_set.map do |record|
        "(#{(Array('?') * record.size).join(',')})"
      end.join(',')

      DB.db.execute("INSERT INTO #{table} (#{columns.join(',')}) VALUES #{fields}", data_set.flatten)
    end

    def self.find(table, query)
      query_statement = query.to_a.map do |pair|
        "#{pair[0]}='#{pair[1]}'"
      end.join('AND')

      DB.db.execute("select * from #{table} where #{query_statement};")
    end

    def self.clean(table)
      DB.db.execute("delete from #{table};")
    end

  end
end