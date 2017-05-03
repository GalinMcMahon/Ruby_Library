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

  def update(title)
  end

  def find_title(title)
  end

  def find_author(author)
  end

end
