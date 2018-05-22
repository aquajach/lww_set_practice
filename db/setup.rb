require "sqlite3"

unless ARGV[0]
  puts 'Error: Missing environment name'
  return
end

# Open a database
db = SQLite3::Database.new "db/#{ARGV[0]}.db"

# Create a table
table = db.execute <<-SQL
  PRAGMA table_info('elements')
SQL

unless (table)
  db.execute <<-SQL
    create table elements (
      set_id varchar(255),
      set_type varchar(255),
      data varchar(255),
      timestamp datetime
    );
  SQL
end

# Add indices
elements_set_id = db.execute <<-SQL
  PRAGMA index_info('elements_set_id')
SQL

unless elements_set_id
  db.execute <<-SQL
    create INDEX elements_set_id on elements (set_id);
  SQL
end

elements_set_type = db.execute <<-SQL
  PRAGMA index_info('elements_set_type')
SQL

unless elements_set_type
  db.execute <<-SQL
    create INDEX elements_set_type on elements (set_type);
  SQL
end