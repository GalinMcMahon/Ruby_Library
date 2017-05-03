require "books"
require "rspec"
require "pry"
require "pg"

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
  end
end


describe('Books') do

  describe('#save') do
    it("creates a new book record in the Books database") do
      test_book = Books.new('Robinson Crusoe', 'Daniel Defoe')
      Books.save(test_book)
      found_DB_object = DB.exec("SELECT * FROM books WHERE title = 'Robinson Crusoe';")
      expect(found_DB_object[0]["title"]).to(eq('Robinson Crusoe'))
    end
  end

end
