# frozen_string_literal: true

module StoreVisits
  def set_visits
    @session_visits = session[:counter] || 0
    session[:counter] = @session_visits
    session[:counter] += 1
  end
end