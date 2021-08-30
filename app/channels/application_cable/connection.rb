module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = authenticated_user
    end

    private

    def authenticated_user
      env['warden'].user
    end
  end
end
