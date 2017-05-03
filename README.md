# Library

### DESCRIPTION

Build a web app using Ruby and postgreSQL to mimic the basic functionality of a library for both an admin and a patron.

### Prerequisites

Web browser with ES6 compatibility
Examples: Chrome, Safari

Ruby <!--VERSION HERE-->
Bundler

### Installing

Installation is quick and easy! First you can open this link <!--HEROKU LINK HERE--> to see the webpage in action live online. Or you can clone this repository to your machine, navigate to the file path in your terminal, and run 'app.rb' by typing '$ruby app.rb'. If you chose to clone the repository, after you run 'app.rb' you will need to copy the localhost path into your web browser. The standard localhost for Sinatra is port 4567

## Built With

* Ruby
* Sinatra
* HTML
* CSS
* Bootstrap https://getbootstrap.com/
* ES6
* Jquery https://jquery.com/
* postgreSQL

## Specifications

| behavior |  input   |  output  |
|----------|:--------:|:--------:|

As a librarian, I want to create, read, update, delete, and list books in the catalog, so that we can keep track of our inventory.
As a librarian, I want to search for a book by author or title, so that I can find a book easily when the book inventory at the library grows large.
As a patron, I want to check a book out, so that I can take it home with me.
As a patron, I want to see a history of all the books I checked out, so that I can look up the name of that awesome sci-fi novel I read three years ago. (Hint: make a checkouts table that is a join table between patrons and books.)
As a patron, I want to know when a book I checked out is due, so that I know when to return it.
As a librarian, I want to see a list of overdue books, so that I can call up the patron who checked them out and tell them to bring them back - OR ELSE!
As a librarian, I want to enter multiple authors for a book, so that I can include accurate information in my catalog. (Hint: make an authors table and a books table with a many-to-many relationship.)

## Authors

* Dominic Brown
* Galen

## License

Copyright © 2017 _** Dominic Brown **_
