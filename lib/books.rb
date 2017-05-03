class Books
  attr_accessor(:title, :author, :due_date)

  def initialize(title, author)
    @title = title
    @author = author
    @due_date = nil
  end

  def self.save(book)
    DB.exec("INSERT INTO books (title, author) VALUES ('#{book.title}', '#{book.author}');")
  end

  def get_list()
  end

  def update()
  end

  def delete()
  end

end
