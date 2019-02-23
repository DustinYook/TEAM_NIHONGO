namespace :background do
  desc "TODO"
  
  task last: :environment do
    require 'one_signal'
    require 'open-uri'
    require 'rufus-scheduler'
    
    
    scheduler = Rufus::Scheduler.new
    scheduler.every '1h' do
      for i in 1..User.count
        user = User.find(i)
        user.message_flag = true
        user.save
        puts user.name + "님 메시지 플래그 초기화"
      end
    end
    
    scheduler.every '5m' do
      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
      currency=doc.css('p.no_today')
      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?
      currency_name=doc.css("h3.h_lst")
      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데
      @new_currency[0].gsub!(",","")
      @new_currency[0].gsub!(" ","")
      @new_currency[0].gsub!("원","")
      rate = @new_currency[0].to_f
      OneSignal::OneSignal.api_key = "N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5"
      OneSignal::OneSignal.user_auth_key = "OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm"
      app_id = "88272bce-6e40-4dd9-9d37-8766fdbfcd99"
      
      
      sendArray = []
      
      for i in 1..User.count
        user = User.find(i)
        if user.subscribe_flag == true and user.rate >= rate and user.message_flag == true and user.onesignal_id != "" and user.rate != 999999.0
        # if user.rate >= rate and user.onesignal_id != ""
  
          sendArray.push(user.onesignal_id)
          user.message_flag = false
          user.save
          puts user.email+"에게 메일 보내기 성공"
        end
      end
      time1 = Time.new
      if sendArray.length != 0
        params ={
          include_player_ids: sendArray,
          app_id: app_id,
          language: "ko",
          contents: {
              en: "지정하신 환율에 도달했습니다: " + rate.to_s + "円"
          }
        }
        OneSignal::Notification.create(params: params)
        puts "=========================================성공============================================="
      else
        puts "보낼 사람이 없습니다"
      end
      puts "알리미 프로세스 완료"
    end
    scheduler.join
  end
  
  
  task oo: :environment do
    require 'one_signal'
    require 'open-uri'
    
    url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
    doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
    currency=doc.css('p.no_today')
    @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?
    currency_name=doc.css("h3.h_lst")
    @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데
    @new_currency[0].gsub!(",","")
    @new_currency[0].gsub!(" ","")
    @new_currency[0].gsub!("원","")
    rate = @new_currency[0].to_f
    OneSignal::OneSignal.api_key = "N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5"
    OneSignal::OneSignal.user_auth_key = "OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm"
    app_id = "88272bce-6e40-4dd9-9d37-8766fdbfcd99"
    
    
    sendArray = []
    
    for i in 1..User.count
      user = User.find(i)
      if user.subscribe_flag == true and user.rate >= rate and user.message_flag == true and user.onesignal_id != "" and user.rate != 999999.0
      # if user.rate >= rate and user.onesignal_id != ""

        sendArray.push(user.onesignal_id)
        user.message_flag = false
        user.save
        puts user.email+"에게 메일 보내기 성공"
      end
    end
    time1 = Time.new
    if sendArray.length != 0
      params ={
        include_player_ids: sendArray,
        app_id: app_id,
        language: "ko",
        contents: {
            en: "지정하신 환율에 도달했습니다: " + rate.to_s + "円" + "Current Time : " + time1.inspect
        }
      }
      OneSignal::Notification.create(params: params)
      puts "=========================================성공============================================="
    else
      puts "보낼 사람이 없습니다"
    end
    puts "알리미 프로세스 완료"
  end
  task testing: :environment do
    require 'rufus-scheduler'
    require 'one_signal'
    require 'open-uri'
    scheduler = Rufus::Scheduler.new
    scheduler.every '20s' do
      puts "10s job"
      puts "Unset message_flag"
      for i in 1..User.count
        user = User.find(i)
        user.message_flag = true
        user.save
      end
    end
    
    scheduler.every '20s' do
      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
      currency=doc.css('p.no_today')
      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?
      currency_name=doc.css("h3.h_lst")
      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데
      @new_currency[0].gsub!(",","")
      @new_currency[0].gsub!(" ","")
      @new_currency[0].gsub!("원","")
      rate = @new_currency[0].to_f
      OneSignal::OneSignal.api_key = "N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5"
      OneSignal::OneSignal.user_auth_key = "OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm"
      app_id = "88272bce-6e40-4dd9-9d37-8766fdbfcd99"
      
      
      sendArray = []
      
      for i in 1..User.count
        user = User.find(i)
        # if user.rate >= rate and user.message_flag == true and user.onesignal_id != ""
        if user.rate >= rate and user.onesignal_id != ""

          sendArray.push(user.onesignal_id)
          user.message_flag = false
          user.save
          puts user.email+"에게 메일 보내기 성공"
        end
      end
      time1 = Time.new
      if sendArray.length != 0
        params ={
          include_player_ids: sendArray,
          app_id: app_id,
          language: "ko",
          contents: {
              en: "지정하신 환율에 도달했습니다: " + rate.to_s + "円" + "Current Time : " + time1.inspect
          }
        }
        OneSignal::Notification.create(params: params)
        puts "=========================================성공============================================="
      else
        puts "보낼 사람이 없습니다"
      end
      puts "20s job"
    end
    scheduler.join
  end
  
  task t: :environment do
    require 'rufus-scheduler'
    # require 'rufus-scheduler'
    require 'one_signal'
    require 'open-uri'
    scheduler = Rufus::Scheduler.new
    scheduler.every '20m' do
      puts "10s job"
      puts "Unset message_flag"
      for i in 1..User.count
        user = User.find(i)
        user.message_flag = true
        user.save
      end
    end
    scheduler.every '10s' do
      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
      currency=doc.css('p.no_today')
      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?
      currency_name=doc.css("h3.h_lst")
      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데
      @new_currency[0].gsub!(",","")
      @new_currency[0].gsub!(" ","")
      @new_currency[0].gsub!("원","")
      rate = @new_currency[0].to_f
      OneSignal::OneSignal.api_key = "N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5"
      OneSignal::OneSignal.user_auth_key = "OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm"
      app_id = "88272bce-6e40-4dd9-9d37-8766fdbfcd99"
      
      
      sendArray = []
      
      for i in 1..User.count
        user = User.find(i)
        if user.rate >= rate and user.message_flag == true and user.onesignal_id != ""
        # if user.rate >= rate and user.onesignal_id != ""

          sendArray.push(user.onesignal_id)
          user.message_flag = false
          user.save
          puts user.email+"에게 메일 보내기 성공"
        end
      end
      time1 = Time.new
      if sendArray.length != 0
        params ={
          include_player_ids: sendArray,
          app_id: app_id,
          language: "ko",
          contents: {
              en: "지정하신 환율에 도달했습니다: " + rate.to_s + "円" + "Current Time : " + time1.inspect
          }
        }
        OneSignal::Notification.create(params: params)
        puts "=========================================성공============================================="
      else
        puts "보낼 사람이 없습니다"
      end
      puts "20s job"
    end
    
    scheduler.join
  end
  task crawling: :environment do
    require 'open-uri'
    
    require 'rufus-scheduler'

    scheduler = Rufus::Scheduler.new
    
    scheduler.every '10s' do
      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
      currency=doc.css('p.no_today')
      @new_currency=currency.map{|cur| cur.text} # 지금 100엔당 얼마인지?
      currency_name=doc.css("h3.h_lst")
      @new_currency_name=currency_name.map{|cur_n| cur_n.text} # 외환명 (지우면 에러)
      @new_currency[0].gsub!(",","")
      @new_currency[0].gsub!(" ","")
      @new_currency[0].gsub!("원","")
      puts @new_currency[0] + "성공"
    end
    
    scheduler.join
  end
  
  task unset: :environment do
    for i in 1..User.count
      user = User.find(i)
      user.message_flag = true
      user.save
    end
  end
  
  task test: :environment do
    
    require 'rufus-scheduler'

    scheduler = Rufus::Scheduler.new
    
    scheduler.every '3s' do
      time1 = Time.new
      puts "Current Time : " + time1.inspect
    end
    
    scheduler.join
  end
  
  task send: :environment do
    
    require 'one_signal'
    require 'rufus-scheduler'
    require 'open-uri'
    time1 = Time.new
    scheduler = Rufus::Scheduler.new
    
    scheduler.every '15s' do
      url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
      doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
      currency=doc.css('p.no_today')
      @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?
      currency_name=doc.css("h3.h_lst")
      @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데
      @new_currency[0].gsub!(",","")
      @new_currency[0].gsub!(" ","")
      @new_currency[0].gsub!("원","")
      rate = @new_currency[0].to_f
      OneSignal::OneSignal.api_key = "N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5"
      OneSignal::OneSignal.user_auth_key = "OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm"
      app_id = "88272bce-6e40-4dd9-9d37-8766fdbfcd99"
      puts rate.to_s
      
      sendArray = []
      
      for i in 1..User.count
        user = User.find(i)
        if user.rate >= rate and user.message_flag == true and user.onesignal_id != ""
          sendArray.push(user.onesignal_id)
          user.message_flag = false
          user.save
        end
      end
      
      if sendArray.length != 0
        params ={
          include_player_ids: sendArray,
          app_id: app_id,
          language: "ko",
          contents: {
              en: "지정하신 환율에 도달했습니다: " + rate.to_s + "円" + "Current Time : " + time1.inspect
          }
        }
        OneSignal::Notification.create(params: params)
        puts "=========================================성공============================================="
      else
        puts "보낼 사람이 없습니다"
      end
    end
    
    scheduler.join
    
  end
  
  
  
end
