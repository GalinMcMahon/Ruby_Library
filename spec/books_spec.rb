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

  describe('.delete') do
    it("returns all books in the database") do
      test_book1 = Books.new('Robinson Crusoe', 'Daniel Defoe')
      test_book1.save
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      Books.delete(test_book2.id)
      expect(Books.all.length).to(eq(1))
    end
  end

  describe('#update') do
    it("updates the title and/or author for a book on the database") do
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      update_hash = {'title' => 'Lord of the Rings'}
      test_book2.update(update_hash)
      DB.exec("SELECT * FROM books WHERE id = '#{test_book2.id}';")
      expect(test_book2.title).to(eq('Lord of the Rings'))
    end
  end

  describe('#update') do
    it("updates the title and/or author for a book on the database") do
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      update_hash = {'title' => 'Lord of the Rings', 'author' => 'Frank Zappa'}
      test_book2.update(update_hash)
      DB.exec("SELECT * FROM books WHERE id = '#{test_book2.id}';")
      expect([test_book2.title, test_book2.author] ).to(eq(['Lord of the Rings','Frank Zappa']))
    end
  end

  describe('.find_by_id') do
    it('returns a book for a given id as it matches in the database') do
      test_book1 = Books.new('Robinson Crusoe', 'Daniel Defoe')
      test_book1.save
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      saved_id = test_book2.save
      expect(Books.find_by_id(saved_id)['title']).to(eq(test_book2.title))
    end
  end

  describe('.find_by_title')
    it('returns a book for a given id as it matches in the database') do
      test_book1 = Books.new('Robinson Crusoe', 'Daniel Defoe')
      test_book1.save
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      expect(Books.find_by_title(test_book2.title)['title']).to(eq("The Hobbit"))
    end
  end

  describe('.find_by_author') do
    it('returns a book for a given id as it matches in the database') do
      test_book1 = Books.new('Robinson Crusoe', 'Daniel Defoe')
      test_book1.save
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      expect(Books.find_by_author(test_book2.author)['author']).to(eq("JRR Tolkien"))
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
