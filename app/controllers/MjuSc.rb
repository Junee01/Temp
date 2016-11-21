#명지대학교 자연캠퍼스
class MjuSc
	#Initialize
	def initialize
		@urls = Array.new
		@urls << "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=36337&id=mjukr_051002050000"	#명진당
		@urls << "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=36548&id=mjukr_051002020000"	#학생회관
		@urls << "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=58976&id=mjukr_051002040000"	#교직원식당

		@parsed_datas = Array.new
		(0..2).each do |i|
			@parsed_datas << Nokogiri::HTML(open(@urls[i]))
		end

		@default_dates = Array.new

		#Init Mon to Fri
		(0..4).each do |i|
	    @default_dates << ((Date.parse @parsed_datas[0].css('div.cafeteria_container tbody')[0].css('tr')[8].text.strip.split("\n")[0]) + i).to_s
	  end
	end #Initialize end

	#Main method scraping
	def scrape
		#명진당
		eachmenus = ''
		currentDate = 0
		(0..4).each do |d|
			#2016-11-20 update "처리내용 : nil error 처리"
			if @parsed_datas[0].css('table.sub')[0].nil? == false
				target = @parsed_datas[0].css('table.sub')[d].css('tbody div')
				target.each do |part|
					tmp_name = part.text.strip.gsub("\t","").gsub("\r\n",",")
					if tmp_name != " "
						if eachmenus == ''
							eachmenus = JSON.generate({:name => tmp_name, :price => ''})
						else
							eachmenus += ',' + JSON.generate({:name => tmp_name, :price => ''})
						end
					end
				end

				if eachmenus != ''
					Diet.create(
						:univ_id => 800,
						:name => "명진당",
						:location => "자연학생식당",
						:date => @default_dates[currentDate],
						:time => "lunch",
						:diet => ArrJson(eachmenus),
						:extra => nil
						)
				end
				eachmenus = ''
			end
			currentDate += 1
		end

		#학생회관
		eachmenus = ''
		currentDate = 0
		(0..4).each do |d|
			#2016-11-20 update "처리내용 : nil error 처리"
			if @parsed_datas[1].css('table.sub')[0].nil? == false
				target = @parsed_datas[1].css('table.sub')[d].css('tbody div')
				target.each do |part|
					tmp_name = part.text.strip.gsub("\t","").gsub("\r\n",",")
					if tmp_name != " "
						if eachmenus == ''
							eachmenus = JSON.generate({:name => tmp_name, :price => ''})
						else
							eachmenus += ',' + JSON.generate({:name => tmp_name, :price => ''})
						end
					end
				end

				if eachmenus != ''
					Diet.create(
						:univ_id => 800,
						:name => "학생회관",
						:location => "자연 캠퍼스 학생회관",
						:date => @default_dates[currentDate],
						:time => "lunch",
						:diet => ArrJson(eachmenus),
						:extra => nil
						)
					Diet.create(
						:univ_id => 800,
						:name => "학생회관",
						:location => "자연 캠퍼스 학생회관",
						:date => @default_dates[currentDate],
						:time => "dinner",
						:diet => ArrJson(eachmenus),
						:extra => nil
						)
				end
				eachmenus = ''
			end
			currentDate += 1
		end

		#교직원식당
		#교직원식당만 아침, 점심, 저녁이 나눠져있다.
		currentTime = 0
		currentDate = 0
		breakfast = ''
		lunch = ''
		dinner = ''

		(0..4).each do |d|
			#2016-11-20 update "처리내용 : nil error 처리"			
			if @parsed_datas[2].css('table.sub')[0].nil? == false
				target = @parsed_datas[2].css('table.sub')[d].css('tbody div')
				(0..2).each do |part|
					tmp_name = target[part].text.strip.gsub("\t","").gsub("\r\n",",")
					if tmp_name != '' && tmp_name != " "
						case currentTime
							when 0 then breakfast = JSON.generate({:name => tmp_name, :price => ''})
							when 1 then lunch = JSON.generate({:name => tmp_name, :price => ''})
							when 2 then dinner = JSON.generate({:name => tmp_name, :price => ''})
						end
					end
					currentTime += 1
				end

				#breakfast
				if breakfast != ''
					Diet.create(
						:univ_id => 800,
						:name => "교직원식당",
						:location => "방목기념관",
						:date => @default_dates[currentDate],
						:time => "breakfast",
						:diet => ArrJson(breakfast),
						:extra => nil
						)
				end

				#lunch
				if lunch != ''
					Diet.create(
						:univ_id => 800,
						:name => "교직원식당",
						:location => "방목기념관",
						:date => @default_dates[currentDate],
						:time => "lunch",
						:diet => ArrJson(lunch),
						:extra => nil
						)
				end

				#dinner
				if dinner != ''
					Diet.create(
						:univ_id => 800,
						:name => "교직원식당",
						:location => "방목기념관",
						:date => @default_dates[currentDate],
						:time => "dinner",
						:diet => ArrJson(dinner),
						:extra => nil
						)
				end
			end
			breakfast = ''
			lunch = ''
			dinenr = ''
			currentTime = 0
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
