class Mailer

  def self.mail(user, message_type)
    mailer_opts = mail_config.merge(to: user.email, body: message(user, message_type))
    Pony.mail(mailer_opts)
  end

  private

  def self.message(user, message_type)
    case message_type
    when :welcome then welcome_message(user.username)
    when :beta_welcome then beta_welcome(user.username)
    when :beta_activated then beta_activated(user.username)
    end
  end


  def self.welcome_message(username)
    %Q{
      Welcome #{username},

      For right now this is just a test email. Please ignore this message.

      Thank you,

      Rook
    }
  end

  def self.beta_welcome(username)
    %Q{
      Thank you for signing up #{username},

      As soon as your account is accepted for Beta Rook, you will be sent an email.

      Thank you,

      Jim Denton
    }
  end

  def self.beta_activated(username)
    %Q{
      #{username}!

      Your account is activated!

      Please - - -
    }
  end

  def self.mail_config
    @mail_config = {
      :via => :smtp, :via_options => {
        address: ENV['EMAIL_ADDRESS'],
        port: ENV['EMAIL_PORT'],
        enable_starttls_auto: ENV['EMAIL_STARTTLS_AUTO'],
        user_name: ENV['EMAIL_USERNAME'],
        password: ENV['EMAIL_PASSWORD'],
        authentication: ENV['EMAIL_AUTHENTICATION'],
        domain: ENV['EMAIL_DOMAIN'] }
    }
  end
end
