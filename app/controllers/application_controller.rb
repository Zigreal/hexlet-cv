# frozen_string_literal: true

require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_root_domain

  self.responder = ApplicationResponder
  respond_to :html, :json

  include Pundit::Authorization
  include Sparkpost
  include Mailer
  include Auth

  before_action :banned?
  helper_method :current_or_guest_user

  def current_or_guest_user
    current_user || guest_user
  end

  def guest_user
    Guest.new
  end

  private

  def redirect_root_domain
    return if request.host == ENV.fetch('HOST')

    redirect_to("#{request.protocol}#{ENV.fetch('HOST')}#{request.fullpath}", status: :moved_permanently)
  end
end
