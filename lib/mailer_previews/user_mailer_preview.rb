class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome(User.first.id)
  end
end
