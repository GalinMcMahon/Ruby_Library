class Books
  attr_accessor(:title, :author, :due_date, :id)

  def initialize(title, author)
    @title = title
    @author = author
    @due_date = nil
    @id = nil
  end

  def save()
    saved_data1 = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = saved_data1[0]["id"].to_i

    saved_data2 = DB.exec("INSERT INTO authors (name) VALUES ('#{@author}') RETURNING id;")
    new_author_id = saved_data2[0]["id"].to_i

    DB.exec("INSERT INTO authors_books (book_id, author_id) VALUES (#{@id}, #{new_author_id});")
    return @id
  end

  def self.all()
    all_books_arr = []
    all_books_tuples = DB.exec("SELECT * FROM books;")
    all_books_tuples.each do |tuple|
      all_books_arr.push(tuple)
    end
    all_books_arr
  end

  def self.delete(id)
    DB.exec("DELETE * FROM books WHERE id = #{id}")
    DB.exec("DELETE * FROM authors_books WHERE book_id = #{id}")
  end

  def self.delete_everything()
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM authors_books *;")
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM patrons *;")
  end

  def self.update(info)
    if (info['title'] != nil)
      title = info['title']
      book_id = info['book_id']
      DB.exec("UPDATE books SET title = '#{title}' WHERE id = #{book_id};")
    end

    if (info['author'] != nil)
      author = info['author']
      book_id = info['book_id']
      results = DB.exec("SELECT author_id FROM authors_books WHERE book_id = #{book_id};")
      author_id = results[0]["author_id"].to_i
      DB.exec("UPDATE authors SET name = '#{author}' WHERE id = #{author_id};")
    end
  end

  def self.find_by_id(id)
    results = DB.exec("SELECT * FROM books WHERE id = #{id};")
    found_book_hash = results[0]
    found_book_hash
    #finish allowing to return author later
  end

  def self.find_by_title(title)
    book_arr = []
    results1 = DB.exec("SELECT * FROM books WHERE title = '#{title}';")
    found_book_title = results1[0]['title']
    found_book_id = results1[0]['id']
    results2 = DB.exec("SELECT author_id FROM authors_books WHERE book_id = #{found_book_id} ;")
    author_id = results2[0]["author_id"].to_i
    results3 = DB.exec("SELECT name FROM authors WHERE id = #{author_id};")
    author_name = results3[0]["name"]
    book_arr.push(found_book_title)
    book_arr.push(author_name)
    book_arr
  end

  def self.find_by_author(author_name)
    book_arr = []
    results1 = DB.exec("SELECT * FROM authors WHERE name = '#{author_name}';")
    found_author_name = results1[0]["name"]
    found_author_id = results1[0]['id']
    results2 = DB.exec("SELECT * FROM authors_books WHERE author_id = #{found_author_id} ;")

    results2.each do |obj|
      book_id = obj[0]['book_id'].to_i
      author_id = obj[0]['author_id'].to_i
      book_result = DB.exec("SELECT title FROM books WHERE id = #{book_id};")
      book_title = book_result[1]
      author_result = DB.exec("SELECT name FROM author WHERE id = #{author_id};")
      author_title = author_result[1]
      book_arr.push({'title' => book_title, 'name' => author_title})
    end

    # book_id = results2[0]["book_id"].to_i
    # results3 = DB.exec("SELECT title FROM books WHERE id = #{book_id};")
    # found_book_title = results3[0]["title"]
    book_arr
  end

  # creates a new row in the CHECKOUTS table and adds the book_id and author_id
  def checkout(patron_id)
    DB.exec("INSERT INTO checkouts (patron_id, book_id) VALUES (#{patron_id}, #{@id});")
    result_rows = DB.exec("SELECT * FROM checkouts WHERE book_id = #{@id};")
    result_rows
  end

  # updates an existing row in CHECKOUTS table to show a real due date (7 days from now)
  def set_due_date()
    # this adds 7 days in seconds (7*24*60*60)
    @due_date = Time.now.+(7*24*60*60).strftime('%Y-%m-%d')
    DB.exec("UPDATE checkouts SET due_date = #{@due_date} WHERE id = #{@id};")
  end

  def add_author(new_author_name)
    @author = new_author_name
    results1 = DB.exec("SELECT author_id FROM authors_books WHERE book_id = #{@id} ;")
    author_id = results1[0]["author_id"].to_i
    DB.exec("UPDATE authors SET name = '#{new_author_name}' WHERE id = #{author_id} ;")
    return author_id
  end

end
