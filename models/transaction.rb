class Transaction < ActiveRecord::Base
  belongs_to :company
  belongs_to :account

  attr_accessor :recurring
end