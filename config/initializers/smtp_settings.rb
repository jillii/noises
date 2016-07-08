ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "gmail.com",
    :user_name => "jho3292@gmail.com",
    :authentication => :plain,
    :enable_starttls_auto => true
}