#한성대학교
class Hansung
	#Initialize
	def initialize
		#URL, <HTML>, Dates
		@url = "http://www.hansung.ac.kr/web/www/life_03_01_t1"
    @parsed_data = Nokogiri::HTML(open(@url))
    @default_dates = Array.new

    #Init Mon to Fri
    (0..4).each do |i|
      @default_dates << ((Date.parse @parsed_data.css('div.menu-wrap h4').text.strip.split(' ')[0]) + i).to_s
    end
  end #Initialize end

	#Main method scraping
	def scrape
		eachmenus = "" #Each menus
		currentDate = 0 #Each Date 'Mon ~ Fri' or 'Mon ~ Sun'

		#학생 중식
		target = @parsed_data.css('tbody tr')[0].css('td')
    (0..4).each do |t|
    	if target[t].inner_html.strip != " "
    		eachmenus = JSON.generate({
    			:name => target[t].inner_html.strip.gsub("<br>",","), 
    			:price => @parsed_data.css('tbody tr th')[0].inner_html.split("<br>")[1].scan(/\d/).join('')}
    			)
				if target[t].inner_html.strip.gsub("<br>",",") != " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
	      	Diet.create(
	        	:univ_id => 3,
	        	:name => "학생식당",
	        	:location => "창의관 지하1층",
	        	:date => @default_dates[currentDate],
	        	:time => 'lunch',
	        	:diet => ArrJson(eachmenus),
	        	:extra => nil
	        	)
				end
    	end
      currentDate += 1
    end

    #학생 석식
    target = @parsed_data.css('tbody tr')[2].css('td')
    currentDate=0

    #석식, 석식은 <td>가 하나 더 있어서 1~5입니다.
    (1..5).each do |t|
    	if target[t].inner_html.strip != " "
    		eachmenus = JSON.generate({
    			:name => target[t].inner_html.strip.gsub("<br>",","), 
    			:price => ""}
    			)
				if target[t].inner_html.strip.gsub("<br>",",") != " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
	      	Diet.create(
	        	:univ_id => 3,
	        	:name => "학생식당",
	        	:location => "창의관 지하1층",
	        	:date => @default_dates[currentDate],
	        	:time => 'dinner',
	        	:diet => ArrJson(eachmenus),
	        	:extra => nil
	        	)
				end
     	end
      currentDate += 1
    end

    #교직원 부분 시작

		#URL, <HTML>
		@url = "http://www.hansung.ac.kr/web/www/life_03_01_t2"
    @parsed_data = Nokogiri::HTML(open(@url))
    currentDate=0

    #교직원 중식
    target = @parsed_data.css('tbody tr')[0].css('td')
    (0..4).each do |t|
    	if target[t].inner_html.strip != " "
    		eachmenus = JSON.generate({
    			:name => target[t].inner_html.strip.gsub("<br>",","), 
    			:price => ""}
    			)
				if target[t].inner_html.strip.gsub("<br>",",") != " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
	      	Diet.create(
	        	:univ_id => 3,
	        	:name => "교직원식당",
	        	:location => "창의관 지하1층",
	        	:date => @default_dates[currentDate],
	        	:time => 'lunch',
	        	:diet => ArrJson(eachmenus),
	        	:extra => nil
	        	)
				end
	    end
      currentDate += 1
    end

    #교직원 석식
    target = @parsed_data.css('tbody tr')[1].css('td')
    currentDate = 0
    (1..5).each do |t|
    	if target[t].inner_html.strip != " "
    		eachmenus = JSON.generate({
    			:name => target[t].inner_html.strip.gsub("<br>",","), 
    			:price => ""}
    			)
				if target[t].inner_html.strip.gsub("<br>",",") != " " #2016-11-06 update "처리내용 : 빈칸일 경우 처리"
	      	Diet.create(
	        	:univ_id => 3,
	        	:name => "교직원식당",
	        	:location => "창의관 지하1층",
	        	:date => @default_dates[currentDate],
	        	:time => 'dinner',
	        	:diet => ArrJson(eachmenus),
	        	:extra => nil
	        	)
				end
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
