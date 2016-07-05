ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "gmail.com",
    :user_name => "jho3292@gmail.com",
    :password => "designer12",
    :authentication => :plain,
    :openssl_verify_mode => 'none'
}