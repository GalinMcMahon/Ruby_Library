require "patrons"
require "books"
require "rspec"
require "pry"
require "pg"

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM patrons *;")
  end
end


describe('Patrons') do

  describe('#save') do
    it("saves the patron's information to the Patrons database") do
      test_patron1 = Patrons.new('Dean Ween')
      test_patron1.save
      found_DB_objects = DB.exec("SELECT * FROM patrons WHERE name = 'Dean Ween';")
      expect(found_DB_objects[0]["name"]).to(eq('Dean Ween'))
    end
  end

  describe('.all') do
    it("returns a list of all patrons") do
      test_patron1 = Patrons.new('Dean Ween')
      test_patron1.save
      test_patron2 = Patrons.new('Gwyneth Paltrow')
      test_patron2.save
      expect(Patrons.all.length).to(eq(2))
    end
  end

end
