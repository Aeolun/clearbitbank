require "clearbit"
require "plaid"
require "models/transaction"
require "models/company"

class Parser
  def import(account, transaction_data)
    transactions = []
    transaction_data.transactions.each do |t|
      transaction = Transaction.where(transaction_id: t.transaction_id).first_or_create

      # unfortunately, it appears that plaid returns transactions with the
      # same id's for all accounts, so this shifts the same transactions around
      # as accounts are loaded.
      transaction.account = account

      transaction.amount = t.amount
      transaction.category_id = t.category_id
      transaction.date = t.date
      transaction.name = t.name
      transaction.pending = t.pending
      transaction.transaction_type = t.transaction_type

      puts "company ", transaction.company
      if transaction.company == nil
        company = determine_company(t.name)

        transaction.company = company
      end

      transaction.save

      transactions.push(transaction)
    end

    transactions
  end

  def determine_company(name)
    puts "get company domain from ", name
    domaininfo = Clearbit::NameDomain.find(name: name)
    puts domaininfo
    company = nil
    if domaininfo
      puts "get company info for ", domaininfo.domain
      c = Clearbit::Enrichment::Company.find(domain: domaininfo.domain, stream: true)

      puts c.to_json
      company = Company.where(company_id: c.id).first_or_create

      company.name = c.name
      company.legal_name = c.legalName
      company.domain = c.domain
      company.sector = c.category.sector
      company.industry_group = c.category.industryGroup
      company.industry = c.category.industry
      company.description = c.description
      company.founded_year = c.foundedYear
      company.logo = c.logo

      company.save
    else
      puts "no domain found"
    end

    company
  end

  def determine_recurring(transactions)
    # This is a really naive method of determining whether something is recurring
    # but really all the payments in the demo api are 100% recurring, so I
    # set it to only detect positive changes as recurring so the interface is
    # not flooded
    initial = {}
    transactions.each do |t|
      if t.amount < 0
        key = t.name + t.amount.to_s

        if initial[key].nil?
          initial[key] = t
          t.recurring = false
        else
          initial[key].recurring = true
          t.recurring = true
        end
      end
    end
  end
end