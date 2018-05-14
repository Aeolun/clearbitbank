class Initialize < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :account
      t.decimal :amount
      t.integer :category_id
      t.date :date
      t.string :name
      t.boolean :pending
      t.string :transaction_id
      t.string :transaction_type

      t.references :company

      t.timestamps
    end

    create_table :companies do |t|
      t.string :company_id
      t.string :name
      t.string :legal_name
      t.string :domain
      t.string :sector
      t.string :industry_group
      t.string :industry
      t.text :description
      t.integer :founded_year
      t.string :logo

      t.timestamps
    end

    create_table :items do |t|
      t.string :item_id
      t.string :access_token

      t.timestamps
    end

    create_table :accounts do |t|
      t.string :account_id
      t.string :name
      t.string :official_name
      t.string :subtype
      t.string :type
      t.decimal :balance_available
      t.decimal :balance_current
      t.decimal :balance_limit
      t.date :last_loaded

      t.references :item

      t.timestamps
    end
  end
end
