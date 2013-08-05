require_relative './associatable'
require_relative './db_connection'
require_relative './mass_object'
require_relative './searchable'
require 'active_support/inflector'


class SQLObject < MassObject
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
    sql_attributes = self.class.attributes.join(",")
  end

  def update
  end

  def save
  end

  def attribute_values
    self.class.attributes.map { |attribute|  self.send("#{attribute}") }
  end
end
