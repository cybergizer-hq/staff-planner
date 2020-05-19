# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def alfred
    @account = Account.from_omniauth(request.env['omniauth.auth'])
    sign_in_and_redirect @account
  end
end
