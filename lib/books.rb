class Books
  attr_accessor(:title, :author, :due_date, :id)

  def initialize(title, author)
    @title = title
    @author = author
    @due_date = nil
    @id = nil
  end

  def save()
    saved_data = DB.exec("INSERT INTO books (title, author) VALUES ('#{@title}', '#{@author}') RETURNING id;")
    # OLD WAY @id = saved_data.first().fetch
    @id = saved_data[0]["id"].to_i
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
    DB.exec("DELETE FROM books WHERE id = '#{id}'")
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

  def checkout(patron_id)
    # assign id to patrons_id
    DB.exec("INSERT INTO checkouts (patron_id, book_id) VALUES (#{patron_id}, #{@id});")
    result_rows = DB.exec("SELECT * FROM checkouts WHERE book_id = #{@id};")
    # update due_date

    result_rows
  end

end




# result.first().fetch("id").to_i()
# result[0]['id']
