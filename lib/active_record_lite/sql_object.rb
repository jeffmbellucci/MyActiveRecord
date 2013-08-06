require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'
require 'active_support/inflector'


class SQLObject < MassObject
  extend Associatable
  extend Searchable
  
  def self.set_table_name(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.class.underscore
  end

  def self.all
    result = DBConnection.execute(<<-SQL) 
    SELECT * FROM #{table_name} 
    SQL
    self.parse_all(result)
  end

  def self.find(id)
   result = DBConnection.execute(<<-SQL, id)
    SELECT * FROM #{table_name} where id = ? 
    SQL
    self.parse_all(result).first
  end

  def create
    attrs = self.class.attributes
    num_questions = attrs.length
    sql_attributes = attrs.join(", ")
    question_marks = (["?"] * num_questions).join(", ")
    p sql_attributes
    p question_marks
    DBConnection.execute(<<-SQL, *attribute_values) 
        INSERT INTO #{self.class.table_name} 
      (#{sql_attributes}) VALUES (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    line = self.class.attributes.map { |attribute| "#{attribute} = ?" }
    line = line.join(", ")
    p line
        DBConnection.execute(<<-SQL, *attribute_values, id)
          UPDATE #{self.class.table_name}
             SET #{line} WHERE id = ?
        SQL
  end

  def save
    update if self.id
    create unless self.id
  end

  def attribute_values
    self.class.attributes.map { |attribute|  self.send("#{attribute}") }
  end
end
