#명지대학교 인문캠퍼스
class Mju
	#Initialize
	def initialize
		#URL, <HTML>, Dates
		@url = "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=3560&id=mjukr_051001030000"
		@parsed_data = Nokogiri::HTML(open(@url))
		@default_dates = Array.new

		#Init Mon to Sun
		(0..6).each do |i|
	    @default_dates << ((Date.parse @parsed_data.css('div.cafeteria_container tbody')[0].css('tr')[8].text.strip.split("\n")[0]) + i).to_s
	  end
	end #Initialize end

	#Main method scraping
	def scrape
		#옛향을 구분하기 위해서 만들었습니다.
		menu_breakfast = ""
	  menu_lunch = ""
	  menu_dinner = ""

	  #학생 식당
	  target = @parsed_data.css('div.cafeteria_container tbody')[0].css('tr')[9].css('td table.sub')
	  currentDate = 0
	  target.each do |table|
	    table.css('tr').each do |t|
	      name = t.css('td')[0].text
	      content = t.css('td')[1].text.gsub("\t","").gsub("\n","").gsub("\r","")
	      price = ''

	      if content == " "	#콘텐츠에 문제가 있으면 Skip
					next
	      end

	      #Json 담기 시작
	      if name == "옛향(아침)"
	      	menu_breakfast += JSON.generate({:name => content, :price => price})
	      elsif name == "옛향(저녁)"
	      	menu_dinner += JSON.generate({:name => content, :price => price})
	      else
	      	if menu_lunch == ""
		        #첫 번째 메뉴면, 콤마없이
		        menu_lunch += JSON.generate({:name => content, :price => price})
		      else
		        #하나 이상 메뉴면 콤마 추가
		       	menu_lunch += (',' + JSON.generate({:name => content, :price => price}))
		      end
	      end
	      #Json 담기 끝
	    end

	    #breakfast
	    if menu_breakfast != ""
		    Diet.create(
	        :univ_id => 4,
	        :name => "학생식당",
	        :location => "학생회관 3층",
	        :date => @default_dates[currentDate],
	        :time => 'breakfast',
	        :diet => ArrJson(menu_breakfast),
	        :extra => nil
	        )
	  	end
	  	#lunch and so on...
	  	if menu_lunch != ""
	  		Diet.create(
	        :univ_id => 4,
	        :name => "학생식당",
	        :location => "학생회관 3층",
	        :date => @default_dates[currentDate],
	        :time => 'lunch',
	        :diet => ArrJson(menu_lunch),
	        :extra => nil
	        )
	  	end
	  	#dinner
	  	if menu_dinner != ""
	  		Diet.create(
	        :univ_id => 4,
	        :name => "학생식당",
	        :location => "학생회관 3층",
	        :date => @default_dates[currentDate],
	        :time => 'dinner',
	        :diet => ArrJson(menu_dinner),
	        :extra => nil
	        )
	  	end

	  	menu_breakfast = ""
	  	menu_lunch = ""
	  	menu_dinner = ""
	    currentDate += 1
	  end

		#교직원 식당
		@url = "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=11619&id=mjukr_051001020000"
	  @parsed_data = Nokogiri::HTML(open(@url))
	  eachmenus = ""
	  time = ''

	  target = @parsed_data.css('div.cafeteria_container tbody')[0].css('tr')[9].css('td table.sub')
	  currentDate = 0
	  target.each do |table|
	    table.css('tbody tr').each do |t|

	    	#time을 결정합니다.
	    	if t.css('td')[0].text[7..8] == "아침"
	        time = 'breakfast'
	      elsif t.css('td')[0].text[7..8] == "점심"
	        time = 'lunch'
	      elsif t.css('td')[0].text[7..8] == "저녁"
	        time = 'dinner'
	      else
	        time = 'breakfast'
	      end

	      if t.css('td')[1].css('p').empty?
	        next
	      else
	        #명지대학교는 휴일에 중식만 표시하는 듯 해서 저녁을 예외처리하였습니다.
	        #수라상A
	        name = t.css('td')[1].css('p')[0].text.gsub("<","").split(">")[0]
	        content = t.css('td')[1].css('p')[0].text.gsub("<","").split(">")[1]
	        price = ''

	        if content == " "	#콘텐츠에 문제가 있으면 Skip
						next
	        end

	        if eachmenus == ""
		        #첫 번째 메뉴면, 콤마없이
		        eachmenus += JSON.generate({:name => content, :price => price})
		      else
		        #하나 이상 메뉴면 콤마 추가
		        eachmenus += (',' + JSON.generate({:name => content, :price => price}))
		      end

		      #수라상B가 있는지 판별하고 작업을 합니다.
		      if t.css('td')[1].css('p')[3].nil?
	          next
					else		          
						#수라상B
						name = t.css('td')[1].css('p')[3].text.gsub("<","").split(">")[0]
		        content = t.css('td')[1].css('p')[3].text.gsub("<","").split(">")[1]
		        price = ''

		        if content == " "	#콘텐츠에 문제가 있으면 Skip
							next
		        end

						if eachmenus == ""
			        #첫 번째 메뉴면, 콤마없이
			        eachmenus += JSON.generate({:name => content, :price => price})
			      else
			        #하나 이상 메뉴면 콤마 추가
			        eachmenus += (',' + JSON.generate({:name => content, :price => price}))
			      end
	        end
	        #수라상B 끝

				end

	      if eachmenus != ""
		  		Diet.create(
		        :univ_id => 4,
		        :name => "교직원식당",
		        :location => "학생회관 2층",
		        :date => @default_dates[currentDate],
		        :time => time,
		        :diet => ArrJson(eachmenus),
		        :extra => nil
		        )
		  	end
		  	eachmenus = ""
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
