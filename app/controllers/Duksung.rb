#덕성여자대학교
class Duksung
  #Initialize
  def initialize
    #URL, Parse <HTML>
    @url = "http://www.duksung.ac.kr/life/foodmenu/index.jsp"
    @parsed_data = Nokogiri::HTML(open(@url),nil,'euc-kr')
		@default_dates = Array.new 
		
    #Init Mon to Fri
    today = Date.today
    while (today.monday? == false)
      today = today - 1
    end 
    d = 0       
    (0..4).each do |d|
      @default_dates << ((Date.parse today.to_s) + d).to_s
    end
  end #Initialize end

	#Main method scraping
	def scrape
    eachmenus = "" #Each menus
		currentDate = 0 #Each Date 'Mon ~ Fri' or 'Mon ~ Sun'

		#교직원 식당
		target = @parsed_data.css('table.menu-table tbody tr')[0].css('td')
    target.each do |t| 
      if t.text[0] != '-'
        if t.text.strip.gsub("\n","").gsub("\r",",").empty? || t.text.strip.gsub("\n","").gsub("\r",",") == " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
          break
        else
          eachmenus = JSON.generate({:name => t.text.strip.gsub("\n","").gsub("\r",","), :price => ''})
          Diet.create(
            :univ_id => 2,
            :name => "교직원식당",
            :location => "학생회관 2층",
            :date => @default_dates[currentDate],
            :time => 'lunch',
            :diet =>  ArrJson(eachmenus),
            :extra => nil
            )
        end
      else
        next
      end
      currentDate += 1
    end

		#학생 식당
		target = @parsed_data.css('table.menu-table tbody tr')[1].css('td')
    eachmenus = ""
    currentDate = 0 #현재 날짜
		target.each do |t|
      if t.text[0] != '-'
        eachmenus = JSON.generate({:name => t.text.strip.split("\r\r")[0].gsub("\n","").gsub("\r",",").gsub("*중식*,",""), :price => ''})
        if t.text.strip.split("\r\r")[0].gsub("\n","").gsub("\r",",").gsub("*중식*,","") != " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
        	Diet.create(
          	:univ_id => 2,
          	:name => "학생식당",
          	:location => "학생회관 2층",
          	:date => @default_dates[currentDate],
          	:time => 'lunch',
          	:diet => ArrJson(eachmenus),
          	:extra => nil
          	)
				end
				if t.text.strip.split("\r\r")[1].nil?
          #Do nothing
        else
          eachmenus = JSON.generate({:name => t.text.strip.split("\r\r")[1].gsub("\n","").gsub("\r",",").gsub("*석식*,",""), :price => ''})
					if t.text.strip.split("\r\r")[1].gsub("\n","").gsub("\r",",").gsub("*석식*,","") != " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
						Diet.create(
            	:univ_id => 2,
            	:name => "학생식당",
            	:location => "학생회관 2층",
            	:date => @default_dates[currentDate],
            	:time => 'dinner',
            	:diet => ArrJson(eachmenus),
            	:extra => nil
            	)
					end
				end
      else
        next
      end
      currentDate += 1
    end

  end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
