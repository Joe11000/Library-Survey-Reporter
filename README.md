# Welcome To My Library Reports Generator App

# 1) Install ruby's package manager
    gem install bundler

# 2) Open the terminal and cd into project

# 3) install gems in from project
    bundle install

# 4) run the tests and make sure everything works. Comprised of RSpec request and system tests
    rspec spec

# 5) start the rails server
    rails s

# 6) go to the html landing page in a browser. There you can enter records manually to create a report, or you can upload a json, xml, or csv file consisting of library records.
    http://localhost:3000

# 7) Submitting either form will direct you to the html report on a seperate page ('/reports')
    ie Sample record files to upload are 
    json --> spec/fixtures/request_bodies/json_files/*
    xml  --> spec/fixtures/request_bodies/xml_files/*
    csv  --> spec/fixtures/request_bodies/csv_files/*
