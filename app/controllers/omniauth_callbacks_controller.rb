# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def alfred
    @account = Account.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @account, event: :authentication
    set_flash_message(:notice, :success, kind: 'Alfred') if is_navigational_format?
  end

  def developer
    @account = Account.first
    sign_in_and_redirect @account, event: :authentication
    set_flash_message(:notice, :success, kind: 'Developer') if is_navigational_format?
  end
end
