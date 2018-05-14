# Rakefile
$: << File.expand_path('../', __FILE__)

require "sinatra/activerecord/rake"
require "./lib/parser"

namespace :db do
  task :load_config do
    require "./app"
  end
end

namespace :clearbit do
  task :update do
    #here goes code to update the balances/transactions that didn't get a company associated once in a while
  end
end