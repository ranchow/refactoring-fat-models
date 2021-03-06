class User < ActiveRecord::Base
  # ...

  def password_authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password
  end

  def token_authenticate(provided_token)
    secure_compare(api_token, provided_token)
  end

private

  # constant-time comparison algorithm to prevent timing attacks
  def secure_compare(a, b)
    return false unless a.bytesize == b.bytesize
    l = a.unpack "C#{a.bytesize}"
    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

end
