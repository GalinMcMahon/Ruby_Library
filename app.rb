require 'sinatra'
require 'sinatra/reloader'
require './lib/books'
require './lib/patrons'
require 'pry'
require 'pg'

also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'library'})

#clear the whole database before testing
# Books.delete_everything

get('/') do
  erb(:index)
end

get('/librarian_home') do
  erb(:librarian_home)
end

get('/patron_home') do
  # Patrons.all returns an array of hashes
  @patrons_arr = Patrons.all
  erb(:patron_home)
end

get('/signup') do
  erb(:patron_form)
end

post('/new_patron_form') do
  patron_new = params.fetch("patron_name")
  @patron_name = patron_new
  new_patron = Patrons.new(patron_new)
  new_patron.save()
  erb(:patron_welcome)
end

get('/patron_name/:id') do
  patron_id = params.fetch('id').to_i
  results = DB.exec("SELECT * FROM patrons WHERE id = #{patron_id};")
  @patron_name = results[0]['name']
  erb(:patron_welcome)
end

post('/title_search') do
  search_title = params.fetch('title')
  @results_arr = Books.find_by_title(search_title)
binding.pry
  erb(:search_results)
end

post('/author_search') do
  search_author = params.fetch('author')
  @results_arr = Books.find_by_author(search_author)
  erb(:search_results)
end


post('/new_book_form') do
  book_new_title = params.fetch("new_book_title")
  book_new_author = params.fetch("new_book_author")
  new_book = Books.new(book_new_title, book_new_author)
  new_book.save()
  @titles_arr = Books.all
  erb(:patron_welcome)
end

get('/book_page/:id') do
  @selected_book_id = params.fetch('id').to_i
  @found_book_title = Books.find_by_id(@selected_book_id)['title']
  found_book_arr = Books.find_by_title(@found_book_title)
  @found_book_author = found_book_arr[1]
  @due_date = DB.exec("SELECT * FROM checkouts WHERE id = #{@selected_book_id};")
  erb(:book_page)
end

post('/update_book_form/:id') do
  @selected_book_id = params.fetch('id').to_i
  @found_book_title = params.fetch('update_book_title')
  @found_book_author = params.fetch('update_book_author')
  found_book_hash = {'title' => @found_book_title, 'author' => @found_book_author , 'book_id' => @selected_book_id}
  Books.update(found_book_hash)
  erb(:book_update_success)
end

get('/success/:id') do
  book_id = params.fetch('id').to_i
  @selected_book_id = params.fetch('id').to_i
  @found_book_title = Books.find_by_id(@selected_book_id)['title']
  found_book_arr = Books.find_by_title(@found_book_title)
  @found_book_author = found_book_arr[1]
  results = DB.exec("SELECT * FROM checkouts WHERE book_id = #{@selected_book_id};")
  if (results.ntuples != 0)
    @due_date = results[0]['due_date']
  else
    @due_date = "No due date for this book yet"
  end
  erb(:book_page)
end
