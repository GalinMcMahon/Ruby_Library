class Books
  attr_accessor(:title, :author, :due_date)

  def initialize(title, author)
    @title = title
    @author = author
    @due_date = nil
  end

  def save()
    DB.exec("INSERT INTO books (title, author) VALUES ('#{@title}', '#{@author}');")
  end

  def self.all()
    all_books_arr = []
    all_books_tuples = DB.exec("SELECT * FROM books;")
    all_books_tuples.each do |tuple|
      all_books_arr.push(tuple)
    end
    all_books_arr
  end

  def find_title(title)
  end

  def find_author(author)
  end

  def update()
  end

  def delete()
  end

end
