class Object
  def new_attr_accessor(*args)
    args.each do |arg|
      define_method("#{arg}") do
        instance_variable_get("@#{arg}")
      end
      define_method("#{arg}=") do |val|
        instance_variable_set("@#{arg}", val)
      end
    end
  end 
end

class Dog
  new_attr_accessor :color, :breed, :name
end

class MassObject 
  def self.set_attrs(*attributes)
    @attributes = attributes
    attributes.each do |attribute|
      attr_accessor(attribute)
    end
  end

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }    
  end
  

  def initialize(params = {})
    params.each do |attr_name, value|
      if self.class.attributes.include?(attr_name.to_sym)
        self.send("#{attr_name}=", value) 
      else
        raise "mass assignment to unregistered attribute #{attr_name}"
      end
    end
  end
      
      
end


