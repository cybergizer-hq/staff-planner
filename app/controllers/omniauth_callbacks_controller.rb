# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @account = Account.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @account
  end

  def alfred
    @account = Account.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @account
  end

  def developer
    @account = Account.first
    sign_in_and_redirect @account, event: :authentication
    set_flash_message(:notice, :success, kind: 'Developer') if is_navigational_format?
  end
end
