module Protectable
  extend ActiveSupport::Concern

  included do
    def user_roles
      @user_roles ||= []
    end

    def tags
      @tags ||= []
    end

  end
end
