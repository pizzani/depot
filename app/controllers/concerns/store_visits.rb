# frozen_string_literal: true

module StoreVisits
  def set_visits
    if session[:counter].nil?
      session[:counter] = 0
      session[:counter] += 1
      @session_visits = session[:counter]
    else
      session[:counter] += 1
      @session_visits = session[:counter]
    end
  end

  def reset_visits
    if session[:counter].nil?
      session[:counter] = 0
      session[:counter] += 1
      @session_visits = session[:counter]
    else
      session[:counter] = 0
      @session_visits = session[:counter]
    end
  end
end