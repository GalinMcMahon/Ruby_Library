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

  def self.all
    all_patrons_arr = []
    all_patrons_tuples = DB.exec("SELECT * FROM patrons;")
    all_patrons_tuples.each do |tuple|
      all_patrons_arr.push(tuple)
    end
    all_patrons_arr
  end

end
