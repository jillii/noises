class UserMailer < ActionMailer::Base
  # default from: "jho3292@gmail.com"
  # layout 'mail_jill'
  def mail_jill(message)
    name = message.name
    email = message.email
    subject = message.subject
    body = message.body

    mail(to: 'jho3292@gmail.com', subject: subject, body: body + "\n\n-" + name, from: email, reply_to: email)
  end
end
