require 'open-uri'
class HomeController < ApplicationController
  before_action :authenticate, only: [:calc, :profile]
  
  def terms
  end
  
  def index 
  end
  
  def team
  end
  
  def calc
    @user = current_user
    @money = 500 * current_user.fhrd + 100 * current_user.hrd + 50 *current_user.fif + 10 * current_user.ten + 5 * current_user.fiv + current_user.one
  end
  
  def profile
    @user = current_user
    @money = 500 * current_user.fhrd + 100 * current_user.hrd + 50 *current_user.fif + 10 * current_user.ten + 5 * current_user.fiv + current_user.one
  end
  
  def setRate
    current_user.rate = params[:rate]
    current_user.save
    redirect_to '/profile'
  end
  
  def setId
    current_user.onesignal_id = params[:id]
    current_user.subscribe_flag = true
    current_user.message_flag = true
    current_user.save
    redirect_to '/profile'
  end
  
  def setSub
    flag = params[:sub]
    puts flag
    if flag == "subscribe"
      current_user.subscribe_flag = true;
      current_user.save
      puts "구독"
    else
      current_user.subscribe_flag = false;
      current_user.save
      puts "구독끊음"
    end
    redirect_to '/profile'
  end
  
  def setCoin
    current_user.fhrd = params[:fhrd_save]
    current_user.hrd = params[:hrd_save]
    current_user.fif = params[:fif_save]
    current_user.ten = params[:ten_save]
    current_user.fiv = params[:fiv_save]
    current_user.one = params[:one_save]
    current_user.save
    redirect_to '/calc'
  end
end