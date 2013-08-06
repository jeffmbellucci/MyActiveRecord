require_relative './db_connection'

module Searchable
  def where(params)
      line = params.map { |key, val| "#{key} = ?" }
      line = line.join(" AND ")

      results = DBConnection.execute(<<-SQL, *params.values)
        SELECT *
          FROM #{table_name}
         WHERE #{line}
      SQL

      parse_all(results)
    end
end