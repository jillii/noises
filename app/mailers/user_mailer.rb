class UserMailer < ActionMailer::Base
  def mail_jill(message)
    name = message.name
    email = message.email
    subject = message.subject
    body = message.body

    mail(to: 'jho3292@gmail.com', subject: subject, body: body + "\n\n-" + name, from: email, reply_to: email)
  end
  def mail_user(user, link)
  	subject = "Someone's uploaded a remix of your track"
  	email = user.email	
    url = link
  	body = "Hey #{user.name}, \n\n#{subject}. Check it out #{link}\n\n-Noises"
    mail(to: email, from: 'jho3292@gmail.com', subject: subject, body: body)
  end
end
