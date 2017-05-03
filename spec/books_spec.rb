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
      test_book.save
      found_DB_objects = DB.exec("SELECT * FROM books WHERE title = 'Robinson Crusoe';")
      expect(found_DB_objects[0]["title"]).to(eq('Robinson Crusoe'))
    end
  end

  describe('.all') do
    it("returns all books in the database") do
      test_book1 = Books.new('Robinson Crusoe', 'Daniel Defoe')
      test_book1.save
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      expect(Books.all.length).to(eq(2))
    end
  end

end






# describe("#id") do
#   it("sets its ID when you save it") do
#     test_doctor = Doctor.new({:doctor_name => "Dr. Jones", :id => nil, :specialty => "Oncologist"})
#     # test_doctor.save()
#     expect(test_doctor.id()).to(eq(nil))
#
# describe("#save") do
#   it("lets you save doctors to the database") do
#     test_doctor = Doctor.new({:doctor_name => "Dr. Jones", :id => nil, :specialty => "Oncologist"})
#     test_doctor.save()
#     expect(Doctor.all()).to(eq([test_doctor]))
