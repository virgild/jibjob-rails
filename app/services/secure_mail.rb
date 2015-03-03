class SecureMail
  attr_reader :user

  def initialize(user)
    raise "Invalid user" if user.nil?
    @user = user
  end

  def wrapped_password_reset_token
    if @user.password_recovery && @user.password_recovery.token
      SecureMail.encrypt_token(@user.password_recovery.token)
    else
      nil
    end
  end

  def self.secret_key
    ENV['PASSWORD_RESET_SECRET']
  end

  def self.encrypt_token(token)
    token.encrypt(:symmetric, password: SecureMail.secret_key)
  end

  def self.decrypt_wrapped_token(wrapped_token)
    begin
      wrapped_token.decrypt(:symmetric, password: SecureMail.secret_key)
    rescue OpenSSL::Cipher::CipherError
      nil
    end
  end
end