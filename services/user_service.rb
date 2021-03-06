class UserService
  def self.create(data)
    data = data.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    user = User.create(data)
    email_on_create(user) if user.id
    user
  end

  def self.update(id, data)
    data = data.reject{ |k,v| v.empty? || v.nil? }
    data = data.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    user = User.first("id" => id)

    if data.include? :skills_desired
      data.merge!(:skills_desired => get_skill_objects(data[:skills_desired].split(/,\s*/)))
    end

    if data.include? :skills_acquired
      data.merge!(:skills_acquired => get_skill_objects(data[:skills_acquired].split(/,\s*/)))
    end

    user.update(data)
    return user
  end

  def self.request_password_reset(email)
    user = User.first(:email => email)
    if ! user.nil?
      user.generate_token
      user.save!
      Mailer.mail(user, :password_reset)
    end
    return user
  end

  def self.password_reset(user_id, password, password_confirmation)
    user = User.first(:id => user_id)
    user.password = password
    user.password_confirmation = password_confirmation
    user.save
    if user.valid?
      user.remove_token!
    end
    return user
  end

  def self.update_password(user_id, passwords)
    passwords = passwords.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    user = User.first(:id => user_id)
    if user.valid_pass?(passwords[:current_password])
      user.password = passwords[:password]
      user.password_confirmation = passwords[:confirm_password]
      user.save
      user
    else
      user.errors.add(:password, "Password incorrect")
      user
    end
  end

  def self.activate_beta_user(users)
    users.each do |user|
      @user = User.first(:id => user.id)
      if @user.activate! == true
        Mailer.mail(@user, :beta_activated)
      else
        puts "#{user.username} wasn't activated"
      end
    end
  end

  def self.get_skill_objects(skills)
    skills.inject([]) do |memo, name|
      memo << Skill.first_or_create(:name => name)
    end
  end

  private

  class << self
    def email_on_create(user)
      Mailer.mail(user, :beta_welcome)
    end
  end
end
