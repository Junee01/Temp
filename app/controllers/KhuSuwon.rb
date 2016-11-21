#경희대학교 수원캠퍼스(801) 2016-11-12 처음 구현한 부분입니다.
class KhuSuwon
	#Initialize
	def initialize
		@url = "http://www.woojungwon.net/Ghostel/mall_main.php?viewform=B0001_foodboard_list&board_no=1&flag=1"	#우정원
		@parsed_data = Nokogiri::HTML(open(@url))	#우정원
	end
	#Initialize end
	
	#Main method scraping
	def scrape

		#우정원
		checkFirstElement = true	#해당 값이 배열의 첫 번째 값인지 확인하기 위한 변수
		currentDate = ''	#현재 날짜 예를 들면, 2016-11-12
		currentTime = 0		#현재 시간 예를 들면, breakfast(0)
		currentTimeName = ''	#현재 시간의 이름 예를 들면, 'breakfast'
		eachmenus = ''	#각각의 메뉴
		
		#첫 번째 파싱 단위
		target = @parsed_data.css('td.body_content').css('tr')

		#우정원은 총 7일단위로 제공중이며, 짝수단위만 의미있는 데이터가 있으므로 6~18까지 짝수만 다룹니다.
		(6..18).each do |i|	#하루단위
			if i%2 == 0
				target[i].css('td').each do |eachTime|	#날짜, 아침, 점심, 저녁단위
					if checkFirstElement == true
						currentDate = eachTime.text
						checkFirstElement = false
					else
						eachTime.text.split("\r\n").each do |eachMenu|	#백반, 분식, 교직원 단위
							if eachmenus == ''
								eachmenus = JSON.generate({:name => eachMenu, :price => ''})
							else
								eachmenus += ',' + JSON.generate({:name => eachMenu, :price => ''})
							end
						end

						case currentTime
							when 0 then currentTimeName = 'breakfast'
							when 1 then currentTimeName = 'lunch'
							when 2 then currentTimeName = 'dinner'
						end

						Diet.create(
							:univ_id => 801,
							:name => "우정원",
							:location => "",
							:date => currentDate,
							:time => currentTimeName,
							:diet => ArrJson(eachmenus),
							:extra => nil
							)

						currentTime += 1
						eachmenus = ''
					end
				end
				currentTime = 0
				currentTimeName = ''
			end
			currentDate = ''
			checkFirstElement = true
		end
	end
	#scrape end
	
	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
