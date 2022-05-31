# frozen_string_literal: true

# Module AuhtHelper prepares authentication header
module AuthHelper
  def http_login
    email = "user@example.com"
    password = "secret"  
    account = Account.create!(email: email, password: password, status: 'verified')
    rodauth = Rodauth::Rails.rodauth
    
    # Prepare JWT token for Authorization header
    @jwt_token ||= begin
      session    = { account_id: account.id }
      jwt_secret = ENV["JWT_SECRET"]
      jwt_algorithm =  "HS256" 
      JWT.encode(session, jwt_secret, jwt_algorithm)
    end
      
    request.env['HTTP_AUTHORIZATION'] = @jwt_token
  end  
end