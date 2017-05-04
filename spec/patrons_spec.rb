require 'spec_helper.rb'

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

  describe('#all_checkouts') do
    it("returns a list of all patrons") do
      test_book1 = Books.new('Robinson Crusoe', 'Daniel Defoe')
      test_book1.save
      test_book2 = Books.new('The Hobbit', 'JRR Tolkien')
      test_book2.save
      test_patron1 = Patrons.new('Dean Ween')
      test_patron1.save
      test_book1.checkout(test_patron1.id)
      test_book1.set_due_date
      test_book2.checkout(test_patron1.id)
      test_book2.set_due_date
      expect(test_patron1.all_checkouts.length).to(eq(2))
    end
  end

end
