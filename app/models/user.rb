class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  
  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end
  
  def can_add_stock?(ticker_symbol)
    # calls the under stock limit and the stock already added methods
    under_stock_limit? && !stock_already_added?(ticker_symbol)
    
  end
  
  # method to check user hasn't reached thier limit of 10 stocks
  def under_stock_limit?
    (user_stocks.count < 10)
  end
  
  # method to check user hasn't already added their stock to their portfolio
  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    
    # checks the db to determine if that user has the stock id assigned to them already
    user_stocks.where(stock_id: stock.id).exists?
  end
end