class Account < ActiveRecord::Base
  belongs_to :item

  has_many :transactions
end