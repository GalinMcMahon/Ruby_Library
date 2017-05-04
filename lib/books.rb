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
    DB.exec("DELETE FROM books WHERE id = #{id}")
    DB.exec("DELETE FROM authors_books WHERE book_id = #{id}")
  end

  def update(info)
    if (info['title'] != nil)
      @title = info['title']
      DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{@id};")
    end
    if (info['author'] != nil)
      @author = info['author']
      DB.exec("UPDATE books SET author = '#{@author}' WHERE id = #{@id};")
    end
  end

  def self.find_by_id(id)
    results = DB.exec("SELECT * FROM books WHERE id = #{id};")
    found_book_hash = results[0]
    found_book_hash
  end

  def self.find_by_title(title)
    results = DB.exec("SELECT * FROM books WHERE title = '#{title}';")
    found_book_hash = results[0]
    found_book_hash
  end

  def self.find_by_author(author)
    results = DB.exec("SELECT * FROM books WHERE author = '#{author}';")
    found_book_hash = results[0]
    found_book_hash
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

end




# result.first().fetch("id").to_i()
# result[0]['id']
