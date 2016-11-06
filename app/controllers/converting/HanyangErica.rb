#한양대학교 에리카 캠퍼스
class HanyangErica
  #Initialize
  def initialize
    @default_dates = Array.new
    @url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=2"
    @parsed_data = Nokogiri::HTML(open(@url))

    #Init Mon to Fri
    (0..6).each do |i|  #일요일까지 있는 경우도 있음.
			@default_dates << ((Date.parse @parsed_data.css('h3.h3Campus03').text.strip.split('(')[1].split(' ')[0]) + i).to_s
    end
  end #Initialize end

	#Main method scraping
	def scrape
    menu = ""
    content = ""
    currentDate = 0 #Start from Mon(0)

		#학생식당
		target = @parsed_data.css('div#sikdang table')

    target.each do |t|
      next_td = 0 #각 메뉴별 즉, <td>
			t.css('td').each do |part|
        if (part.nil? || part.text == " ")
          #Do nothing
        elsif (part.text == "중식")
          #Do nothing
        elsif (next_td % 2 == 1)  #홀수
					if part.text != " "
            content = part.text
          else
          end
        elsif (next_td % 2 == 0) #짝수
					price = part.text.scan(/\d/).join('')  #price가 완료되면, 객체 생성
					if menu == ""
            #첫 번째 메뉴면, 콤마없이
            menu += JSON.generate({:name => content, :price => price})
          else
            #하나 이상 메뉴면 콤마 추가
            menu += (',' + JSON.generate({:name => content, :price => price}))
          end
        else
        end
      else
        puts "nothing"
      end
      next_td += 1
    end
    if menu != ""
      Diet.create(
        :univ_id => 10,
        :name => "학생식당",
        :location => "복지관 2층",
        :date => @default_dates[currentDate],
        :time => 'lunch',
        :diet => ArrJson(menu),
        :extra => nil
        )
    end
    menu = "" #menu 초기화
		currentDate += 1

		#금요일까지 했으면 끝
		if (currentDate == 5)
      break
    end
  end #학생식당 끝

	#창의인재원식당
	@url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=3"
  @parsed_data = Nokogiri::HTML(open(@url))
  content = ""
  time = ""
  currentDate=0
  checkfirst=0
  menu = ""

  target = @parsed_data.css('div#sikdang table')
  target.each do |t|  #each tables
		#일요일까지 했으면 Stop
		if currentDate == 7
      break
    end

    t.css('tr').each do |part1| #each <tr>
			if checkfirst == 0
        checkfirst = 1
        next
      end
      next_td=0
      part1.css('td').each do |part2| #each <td>
				if (part2.text == "조식")
          time = 'breakfast'
          menu = ""
        elsif (part2.text == "중식")
          if menu != ""
            Diet.create(
              :univ_id => 10,
              :name => "창의인재원식당",
              :location => "창의관 1층",
              :date => @default_dates[currentDate],
              :time => time,
              :diet => ArrJson(menu),
              :extra => nil
              )
          end
          time = 'lunch'
          menu = ""
        elsif (part2.text == "석식")
          if menu != ""
            Diet.create(
              :univ_id => 10,
              :name => "창의인재원식당",
              :location => "창의관 1층",
              :date => @default_dates[currentDate],
              :time => time,
              :diet => ArrJson(menu),
              :extra => nil
              )
          end
					time = 'dinner'
          menu = ""
        elsif (next_td % 2 == 1)  #홀수
					content = part2.text
        elsif (next_td % 2 == 0) #짝수
					price = part2.text.scan(/\d/).join('')
          if (content == " " || content == "  ")  #이 곳에 사용된 빈칸은 그냥 빈칸이 아님.
						next
          else
            if menu == ""
            	#첫 번째 메뉴면, 콤마없이
            	menu += JSON.generate({:name => content, :price => price})
            else
              #하나 이상 메뉴면 콤마 추가
              menu += (',' + JSON.generate({:name => content, :price => price}))
            end
          end
        else
          #Do nothing
        end
        next_td += 1
      end
      if menu != ""
        Diet.create(
          :univ_id => 10,
          :name => "창의인재원식당",
          :location => "창의관 1층",
          :date => @default_dates[currentDate],
          :time => time,
          :diet => ArrJson(menu),
          :extra => nil
          )
      end
      time = 'breakfast'
      menu = ""
    end
    currentDate += 1
  end #창의원인재식당

	#교직원 식당
	@url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=1"
  @parsed_data = Nokogiri::HTML(open(@url))
  content = ""
  time = ""
  currentDate=0
  checkfirst=0
  menu = ""

  target = @parsed_data.css('div#sikdang table')
  target.each do |t|  #each tables
		if currentDate == 5
      break
    end

    t.css('tr').each do |part1| #each <tr>
			if checkfirst == 0
        checkfirst = 1
        next
      end
      next_td=0
      part1.css('td').each do |part2| #each <td>
				if (part2.text == "중식")  #From here time is lunch
					time = 'lunch'
          menu = ""
        elsif (part2.text == "석식") #From here time is dinner
					#Before start dinner insert into diet value "lunchs."
					if menu != ""
            Diet.create(
              :univ_id => 10,
              :name => "교직원식당",
              :location => "복지관 3층",
              :date => @default_dates[currentDate],
              :time => time,
              :diet => ArrJson(menu),
              :extra => nil #NULL
							)
            end
            time = 'dinner'
            menu = ""
          elsif (next_td % 2 == 1)  #홀수
						content = part2.text
          elsif (next_td % 2 == 0) #짝수
						price = part2.text.scan(/\d/).join('')
            if content != " "
              if menu == ""
                #첫 번째 메뉴면, 콤마없이
                menu += JSON.generate({:name => content, :price => price})
              else
                #하나 이상 메뉴면 콤마 추가
                menu += (',' + JSON.generate({:name => content, :price => price}))
              end
            else
              next
            end
          else
          end
          next_td += 1
        end
				#Before start next table insert into diet value "dinners."
				if menu != ""
          Diet.create(
            :univ_id => 10,
            :name => "교직원식당",
            :location => "복지관 3층",
            :date => @default_dates[currentDate],
            :time => time,
            :diet => ArrJson(menu),
            :extra => nil #NULL
						)
        end
        time = 'lunch'
        menu = ""
      end
      currentDate += 1
    end #교직원 식당 끝

		#창업보육센터
		@url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=5"
    @parsed_data = Nokogiri::HTML(open(@url))
    content = ""
    price = ""
    time = ""
    currentDate = 0
    menu = ""

		target = @parsed_data.css('div#sikdang table')
    target.each do |t|
      t.css('td').each do |part|
        if (part.nil? || part.text == " ")
          #Do nothing
          elsif (part.text == "중식")
          time = 'lunch'
        elsif (part.text == "석식")
          if menu != ""
            Diet.create(
              :univ_id => 10,
              :name => "창업보육센터",
              :location => "창업보육센터 지하1층",
              :date => @default_dates[currentDate],
              :time => time,
              :diet => ArrJson(menu),
              :extra => nil
              )
          end
          time = 'dinner'
          menu = ""
        elsif ((part.text.reverse[0..2] =~ /\A\d+\z/) == 0) #숫자로만 이루어져 있다면 마지막 세자리가 숫자라면
					next
        else
          content = part.text
          price = part.next.next.text.scan(/\d/).join('')
          if content == " " #content에 문제가 있으면 생성 x
						next
          end
          if menu == ""
            #첫 번째 메뉴면, 콤마없이
            menu += JSON.generate({:name => content, :price => price})
          else
            #하나 이상 메뉴면 콤마 추가
            menu += (',' + JSON.generate({:name => content, :price => price}))
          end
        end
      end #t.css('td').each do |part| 의 end
			if menu != ""
        Diet.create(
          :univ_id => 10,
          :name => "창업보육센터",
          :location => "창업보육센터 지하1층",
          :date => @default_dates[currentDate],
          :time => time,
          :diet => ArrJson(menu),
          :extra => nil
          )
      end
      time = 'lunch'
      menu = ""
      currentDate += 1
        
      #금요일까지 하고 끝
      if (currentDate == 5)
        break
      end
    end #창업보육센터 끝

		#마인드 푸드코트
		@url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=4"
    @parsed_data = Nokogiri::HTML(open(@url))
    price = ""
    content = ""
    currentDate = 0
    menu = ""

    target = @parsed_data.css('div#sikdang table')
    target.each do |t|
      t.css('td').each do |part|
        if (part.nil? || part.text.strip == " ")
          #Do nothing
        elsif (part.text == "한식")
          #Do nothing
        elsif (part.text == "양식")
          #한식 처리 완료
        elsif (part.text == "분식")
          #양식 처리 완료
        elsif (part.text.reverse[0..2] =~ /\A\d+\z/) == 0 #숫자로만 이루어져 있다면 마지막 세자리가 숫자라면
					next
        else
          content = part.text.strip.gsub("  ","")
          price = part.next.next.text.scan(/\d/).join('')
          if price.empty?
            next
          else
            if menu == ""
              #첫 번째 메뉴면, 콤마없이
              menu += JSON.generate({:name => content, :price => price})
            else
              #하나 이상 메뉴면 콤마 추가
              menu += (',' + JSON.generate({:name => content, :price => price}))
            end
          end
        end
      end

			if menu != ""
        Diet.create(
          :univ_id => 10,
          :name => "마인드 푸드코트",
          :location => "복지관 3층",
          :date => @default_dates[currentDate],
          :time => 'breakfast',
          :diet => ArrJson(menu),
          :extra => nil
          )
        Diet.create(
          :univ_id => 10,
          :name => "마인드 푸드코트",
          :location => "복지관 3층",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet => ArrJson(menu),
          :extra => nil
          )
        Diet.create(
          :univ_id => 10,
          :name => "마인드 푸드코트",
          :location => "복지관 3층",
          :date => @default_dates[currentDate],
          :time => 'dinner',
          :diet => ArrJson(menu),
          :extra => nil
          )
      end
			menu = ""
      currentDate += 1
        
      #금요일까지 하고 끝
      if (currentDate == 5)
        break
      end
    end #마인드 푸드코트 끝

	end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #class end
