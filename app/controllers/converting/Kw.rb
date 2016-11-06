#광운대학교 일반
class Kw
  #Initialize
  @url = "http://www.kw.ac.kr/sub/life/uniguide18_1CP.do"
  @parsed_data = Nokogiri::HTML(open(@url))
  @default_dates = Array.new

  #Init Mon to Fri
  (0..4).each do |i|
      @default_dates << ((Date.parse @parsed_data.css('div.search_day').text[0..9]) + i).to_s
    end
  end #Initialize end

	#Main method scraping
	def scrape
    currentDate = 0
    content = ''
    eachmenu = ''
    
    #조식, 중식
    if @parsed_data.css('div.menu_table tr')[2].nil? == false
      target = @parsed_data.css('div.menu_table tr')[2].css('td')
      target.each do |t|
        content = t.inner_html.gsub('<br>',",").strip
        eachmenu = JSON.generate({:name => content, :price => '2,500'})
        if content == ""
          break
        else
          Diet.create(
            :univ_id => 8,
            :name => "함지마루",
            :location => "복지관 학생식당",
            :date => @default_dates[currentDate],
            :time => 'lunch',
            :diet => ArrJson(eachmenu),
            :extra => ''
            )
        end
        currentDate += 1
      end
    end

    #석식
    if @parsed_data.css('div.menu_table tr')[3].nil? == false
      target = @parsed_data.css('div.menu_table tr')[3].css('td')
      currentDate = 0
      content = ''
      target.each do |t|
        content = t.inner_html.gsub('<br>',",").strip
        eachmenu = JSON.generate({:name => content, :price => '2,500'})
        if content == ""
          #Do nothing
        else
          Diet.create(
            :univ_id => 8,
            :name => "함지마루",
            :location => "복지관 학생식당",
            :date => @default_dates[currentDate],
            :time => 'dinner',
            :diet => ArrJson(eachmenu),
            :extra => ''
            )
        end
        currentDate += 1
      end
    end

    #푸드코트는 따로 KwFoodCort로 처리.

	end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
