class UserMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find(user_id)
    mail(:to => @user.email, :subject => "Your Daybreakers.co account is ready!")
  end
end
