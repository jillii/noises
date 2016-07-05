# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "jho3292@gmail.com"
  layout 'mailer'
end
