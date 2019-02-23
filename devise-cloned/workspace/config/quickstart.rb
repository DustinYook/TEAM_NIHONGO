require 'rufus-scheduler'

scheduler = Rufuss::Scheduler.new

scheduler.every '3m' do
    require 'one_signal'
    url='https://finance.naver.com/marketindex/exchangeDetail.nhn?marketindexCd=FX_JPYKRW_SHB'
    doc=Nokogiri::HTML(open(url),nil, 'euc-kr')
    currency=doc.css('p.no_today')
    @new_currency=currency.map{|cur| cur.text} #지금 100엔당 얼마인지?
    currency_name=doc.css("h3.h_lst")
    @new_currency_name=currency_name.map{|cur_n| cur_n.text} #외환명이라는데
    u_rate = current_user.rate.to_f
    @new_currency[0].gsub!(",","")
    @new_currency[0].gsub!(" ","")
    @new_currency[0].gsub!("원","")
    rate = @new_currency[0].to_f
    OneSignal::OneSignal.api_key = "N2YwYjc1MjItNGVmZS00YmVjLWE5NjUtMzBmMDUzMDJiNzY5"
    OneSignal::OneSignal.user_auth_key = "OWE3NWM4NDYtMTMyZi00NGM1LTgyOGYtODY4NzRlYThlZjVm"
    app_id = "88272bce-6e40-4dd9-9d37-8766fdbfcd99"
    
    params = {
        app_id: app_id
    }
    
    response = OneSignal::Player.all(params: params)
    count = JSON.parse(response.body)["total_count"].to_i
    puts "-----------------------------"+ count.to_s + "---------------------------------------"
    idArray = []
    
    for i in 0..count-1
      idArray.push(JSON.parse(response.body)["players"][i]["id"])
      puts "-------------------------------" + JSON.parse(response.body)["players"][i]["id"].to_s + "================================="
      puts "===================================" + idArray[i] + "============================================="
    end
    
    sendArray = []
    
    for i in 0..count-1
      response = OneSignal::Player.get(id: idArray[i])
      if u_rate >= rate and current_user.message_flag == true
        sendArray.push(idArray[i])
        user_array = User.where(onesignal_id: idArray[i])
        user = user_array[0]
        user.message_flag = false
        user.save
        puts "@@@@@@@@@@@@@@@@@@@@@@@@" + sendArray[i] + "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        puts "---------------------------%"+ idArray[i].to_s + "%%%%%%----------------------------"
      end
    end
    
    # puts "==============================" +sendArray[0] + "''''''''''''''''''''''''''''''''''''''''"
    
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
      puts "그런거 없음니다"
    end
    redirect_to '/rate'
end
