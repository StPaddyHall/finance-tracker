class UsersController < ApplicationController
   def my_portfolio
      # gets the many to many association
      @user_stocks = current_user.stocks
      @user = current_user
   end
end