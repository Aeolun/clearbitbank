Setup
-----

Install the correct ruby version with `rbenv`. The application was built on ruby 2.5.1.

Afterwards confirm `bundle` is installed, and run `bundle install`. This should set up everything you need to run the application.

Usage
-----

The application can be started with `ruby app.rb`.

Tests
-----
Before you can run the tests you first need to create the test database.

Run:
```bash
RACK_ENV=test bundle exec rake db:migrate
```

After that tests should work with:
```bash
ruby test.rb
```