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
				#2016-11-07 update "빈칸 처리"
				content = t.css('td')[1].text.gsub("\t","").gsub("\n","").gsub("\r","").gsub("  ","")
				price = ''

				#콘텐츠에 문제가 있으면 Skip
				#2016-11-06 update "의미없는 빈칸 또는 데이터가 없는 경우 처리"
				#2016-11-07 update "빈칸 처리2"
				if (content == " ") || (content == "                                             ") || (content.empty?)
					puts "Something wrong in content."
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
		#2016-11-10 update "처리내용 :구조가 완전히 바뀌어 전체 새로 교체"
		@url = "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=11619&id=mjukr_051001020000"
		@parsed_data = Nokogiri::HTML(open(@url))
		eachmenus = ""
		time = 0
		currentDate = 0
		time_str = ''

		#2016-11-20 update "처리내용 :nil error 처리"
		if @parsed_data.css('table.sub')[0].nil? == false
			(0..4).each do |d|
				target = @parsed_data.css('table.sub')[d].css('tbody div')
				target.each do |t|
					case time
						when 0 then time_str = "breakfast"
						when 1 then time_str = "lunch"
						when 2 then time_str = "dinner"
					end

					content = t.text.strip.gsub("\r","").gsub("\n",",").gsub("  ","")
					if content != ""
						eachmenus = JSON.generate({:name => content, :price => ''})
						Diet.create(
							:univ_id => 4,
							:name => "교직원식당",
							:location => "학생회관 2층",
							:date => @default_dates[currentDate],
							:time => time_str,
							:diet => ArrJson(eachmenus),
							:extra => nil
							)
					end

					time = time + 1
				end

				time = 0
				currentDate += 1
			end
		end

	end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
