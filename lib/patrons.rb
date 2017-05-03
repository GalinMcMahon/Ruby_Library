class Patrons
  attr_accessor(:name, :id)

  def initialize(name)
    @name = name
    @id = nil
  end

  def save
    saved_data = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = saved_data[0]["id"].to_i
  end

end
