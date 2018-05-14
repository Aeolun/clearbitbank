$: << File.expand_path('../', __FILE__)

require 'sinatra'
require "sinatra/activerecord"
require 'dotenv/load'
require "plaid"
require "clearbit"

require "models/account"
require "models/item"

require "lib/parser"

set :database_file, "config/database.yml"

configure do
  set :bind, '0.0.0.0'
end

client = Plaid::Client.new(env: :sandbox,
                           client_id: ENV['PLAID_CLIENT_ID'],
                           secret: ENV['PLAID_SECRET'],
                           public_key: ENV['PLAID_PUBLIC_KEY'])
Clearbit.key = ENV['CLEARBIT_KEY']

get '/' do
  @items = Item.all

  erb :index
end

get '/item/:id' do
  @item = Item.find_by_id(params[:id])

  erb :item
end

get '/account/:id' do
  @account = Account.find_by_id(params[:id])

  puts @account.to_json
  parser = Parser.new

  now = Date.today
  from_date = (now - 60)

  if not @account.last_loaded.nil? and @account.last_loaded.to_date == now.to_date
    @transactions = @account.transactions.order(date: :desc)
  else
    begin
      transactions_response = client.transactions.get(@account.item.access_token, from_date, now)

      @transactions = parser.import(@account, transactions_response)
      @account.last_loaded = now.to_date

      @account.save
    rescue Plaid::ItemError => e
      transactions_response = { error: {error_code: e.error_code, error_message: e.error_message}}

      # Should have slightly more elegant solution here
      @transactions = []
    end
  end

  parser.determine_recurring(@transactions)

  erb :account
end

post '/get_access_token' do
  exchange_token_response = client.item.public_token.exchange(params['public_token'])

  access_token = exchange_token_response['access_token']
  item_id = exchange_token_response['item_id']

  item = Item.new
  item.item_id = item_id
  item.access_token = access_token
  item.save

  auth_response = client.auth.get(item.access_token)

  auth_response.accounts.each do |a|
    account = Account.new
    account.account_id = a.account_id
    account.name = a.name
    account.official_name = a.official_name
    account.balance_available = a.balances.available
    account.balance_current = a.balances.current
    account.balance_limit = a.balances.limit

    account.item = item

    account.save
  end

  exchange_token_response.to_json
end