#한양대학교 에리카 캠퍼스
class HanyangErica
  #초기화 작업
  def initialize
    #이 학교는 '창의인재원식당'이 주말에도 운영하므로 주말까지 총 7일을 계산.
    #또한 URL이 각 날짜마다 다르므로 각각의 URL을 모두 따로 조사해야함.
    @default_dates = Array.new
    today = Date.today

    while (today.monday? == false)
      today = today - 1
    end

    (0..6).each do |d|
      @default_dates << ((Date.parse today.to_s) + d).to_s
    end

    @urls = Array.new
    @parsed_data = Array.new
    @array_of_menuNames = Array.new
    @array_of_menuPrice = Array.new
  end
  #초기화 작업 끝

	#Main method scraping
	def scrape
    json_menus = ''
    currentDate = 0

		#교직원 식당
		(0..4).each do |d|
      @urls << "http://www.hanyang.ac.kr/web/www/-254?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay=" + (Date.parse @default_dates[d]).day.to_s + "&_foodView_WAR_foodportlet_sFoodDateYear=" + (Date.parse @default_dates[d]).year.to_s + "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth=" + ((Date.parse @default_dates[d]).month-1).to_s
      @parsed_data << Nokogiri::HTML(open(@urls[d]))
    end

    (0..4).each do |d|
      #교직원 식당 - 중식
      #각각의 식단 이름을 하나씩 저장한다.
      @parsed_data[d].css('div.in-box')[0].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[0].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

			if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "교직원식당",
          :location => "학생회관 2층",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      #교직원 식당 - 석식
      @parsed_data[d].css('div.in-box')[1].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[1].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "교직원식당",
          :location => "학생회관 2층",
          :date => @default_dates[currentDate],
          :time => 'dinner',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

			@array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      currentDate = currentDate + 1
    end
    #교직원 식당 끝

    @urls.clear
    @parsed_data.clear
    currentDate = 0

    #학생식당
    (0..4).each do |d|
      @urls << "http://www.hanyang.ac.kr/web/www/-255?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay=" + (Date.parse @default_dates[d]).day.to_s + "&_foodView_WAR_foodportlet_sFoodDateYear=" + (Date.parse @default_dates[d]).year.to_s + "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth=" + ((Date.parse @default_dates[d]).month-1).to_s
      @parsed_data << Nokogiri::HTML(open(@urls[d]))
    end

    (0..4).each do |d|
      #학생식당 - 중식
      shared_menu = ''   #공통찬
			shared_menu = @parsed_data[d].css('div.in-box')[1].css('tbody tr td').text.strip

      #각각의 식단 이름을 하나씩 저장한다.
      @parsed_data[d].css('div.in-box')[0].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","") + ',' + shared_menu
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[0].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "학생식당",
          :location => "복지관 2층",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      currentDate = currentDate + 1
    end
    #학생식당 끝

		@urls.clear
    @parsed_data.clear
    currentDate = 0
    shared_menu = ''

    #창의인재원식당
    (0..6).each do |d|
      @urls << "http://www.hanyang.ac.kr/web/www/-256?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay=" + (Date.parse @default_dates[d]).day.to_s + "&_foodView_WAR_foodportlet_sFoodDateYear=" + (Date.parse @default_dates[d]).year.to_s + "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth=" + ((Date.parse @default_dates[d]).month-1).to_s
      @parsed_data << Nokogiri::HTML(open(@urls[d]))
    end

    (0..6).each do |d|
      #창의인재원식당 - 조식

			#각각의 식단 이름을 하나씩 저장한다.
			@parsed_data[d].css('div.in-box')[0].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[0].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "창의인재원식당",
          :location => "창의관 1층",
          :date => @default_dates[currentDate],
          :time => 'breakfast',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      #창의인재원식당 - 중식
      @parsed_data[d].css('div.in-box')[1].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[1].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "창의인재원식당",
          :location => "창의관 1층",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      #창의인재원식당 - 석식
      @parsed_data[d].css('div.in-box')[2].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[2].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "창의인재원식당",
          :location => "창의관 1층",
          :date => @default_dates[currentDate],
          :time => 'dinner',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      currentDate = currentDate + 1
    end
    #창의인재원식당 끝

		@urls.clear
    @parsed_data.clear
    currentDate = 0

    #푸드코트
    (0..4).each do |d|
      @urls << "http://www.hanyang.ac.kr/web/www/-257?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay=" + (Date.parse @default_dates[d]).day.to_s + "&_foodView_WAR_foodportlet_sFoodDateYear=" + (Date.parse @default_dates[d]).year.to_s + "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth=" + ((Date.parse @default_dates[d]).month-1).to_s
      @parsed_data << Nokogiri::HTML(open(@urls[d]))
    end

    #분식을 공통찬으로 처리한다. 중식부터 석식까지 제공되므로
    array_of_foodCort_shard_menuNames = Array.new
    array_of_foodCort_shard_menuPrice = Array.new
    json_menus_foodCort = ''

    (0..4).each do |d|
      #각각의 식단 이름을 하나씩 저장한다.
      @parsed_data[d].css('div.in-box')[0].css('h3').each do |part|
        array_of_foodCort_shard_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[0].css('p.price').each do |part|
        array_of_foodCort_shard_menuPrice << part.text
      end

      (array_of_foodCort_shard_menuNames.length).times do |i|
        if json_menus_foodCort == ""
          json_menus_foodCort = JSON.generate({:name => array_of_foodCort_shard_menuNames[i], :price => array_of_foodCort_shard_menuPrice[i]})
        else
          json_menus_foodCort += ',' + JSON.generate({:name => array_of_foodCort_shard_menuNames[i], :price => array_of_foodCort_shard_menuPrice[i]})
        end
      end

      #중식/석식
      @parsed_data[d].css('div.in-box')[1].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[1].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      #분식은 중식과 석식에 모두 들어가고, 중식/석식이 함께 뭉쳐져 있어서 중복되는 메뉴가 나타나는 것이 정상.
      json_menus += ',' + json_menus_foodCort

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "푸드코트",
          :location => "복지관 3층",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "푸드코트",
          :location => "복지관 3층",
          :date => @default_dates[currentDate],
          :time => 'dinner',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      array_of_foodCort_shard_menuNames.clear
      array_of_foodCort_shard_menuPrice.clear
      json_menus_foodCort = ''

      currentDate = currentDate + 1
    end
    #푸드코트 끝

		@urls.clear
    @parsed_data.clear
    currentDate = 0

    #창업보육센터
    (0..4).each do |d|
      @urls << "http://www.hanyang.ac.kr/web/www/-258?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay=" + (Date.parse @default_dates[d]).day.to_s + "&_foodView_WAR_foodportlet_sFoodDateYear=" + (Date.parse @default_dates[d]).year.to_s + "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth=" + ((Date.parse @default_dates[d]).month-1).to_s
      @parsed_data << Nokogiri::HTML(open(@urls[d]))
    end

    (0..4).each do |d|
      #창업보육센터 - 중식
      #각각의 식단 이름을 하나씩 저장한다.
      @parsed_data[d].css('div.in-box')[0].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[0].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "창업보육센터",
          :location => "	창업보육센터 지하1층",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      #교직원 식당 - 석식
      @parsed_data[d].css('div.in-box')[1].css('h3').each do |part|
        @array_of_menuNames << part.text.gsub("\t","").gsub("\r","").gsub("\n","")
      end
      #각각의 식단 가격을 하나씩 저장한다. 이는 @array_of_menuNames와 1:1로 매칭된다.
      @parsed_data[d].css('div.in-box')[1].css('p.price').each do |part|
        @array_of_menuPrice << part.text
      end

      (@array_of_menuNames.length).times do |i|
        if json_menus == ""
          json_menus = JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        else
          json_menus += ',' + JSON.generate({:name => @array_of_menuNames[i], :price => @array_of_menuPrice[i]})
        end
      end

      if json_menus != ''
        Diet.create(
          :univ_id => 10,
          :name => "창업보육센터",
          :location => "	창업보육센터 지하1층",
          :date => @default_dates[currentDate],
          :time => 'dinner',
          :diet =>  ArrJson(json_menus),
          :extra => nil
          )
      end

      @array_of_menuNames.clear
      @array_of_menuPrice.clear
      json_menus = ''

      currentDate = currentDate + 1
    end

    @urls.clear
    @parsed_data.clear
    currentDate = 0

	end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #class end
