#광운대학교 푸드코트
class KwFoodCort
  #Initialize
  def initialize
    @urls = Array.new
    #위부터 순서대로 중식/한식/철판/일식/쌀국수/요리부
    @urls << "http://foodcourt.kw.ac.kr/menu/menu_chinesefood.html"
    @urls << "http://foodcourt.kw.ac.kr/menu/menu_university.html"
    @urls << "http://foodcourt.kw.ac.kr/menu/menu_grilledfood.html"
    @urls << "http://foodcourt.kw.ac.kr/menu/menu_westernfood.html"
    @urls << "http://foodcourt.kw.ac.kr/menu/menu_snackfood.html"
    @urls << "http://foodcourt.kw.ac.kr/menu/menu_dish.html"

    @parsed_data = Array.new
    @urls.each do |url|
      #'EUC-KR 로 Encoding 해야만 합니다.'
      @parsed_data << Nokogiri::HTML(open(url),nil,'euc-kr')
    end

    #Init Mon to Fri
    @default_dates = Array.new
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
    eachmenus = ''
    content = ''
    price = ''

    #푸드코트
    (0..4).each do |currentDate|
      #중식
      target = @parsed_data[0].css('table.line00 tr')[3].css('table')[1].css('tr')
      
      (1..16).each do |i|
        content = target[i].css('td')[2].text.gsub("\r","").gsub("\t","").gsub("\n","")
        price = target[i].css('td')[3].text
        if eachmenus == ""
          #첫 번째 메뉴면, 콤마없이
          eachmenus += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          eachmenus += (',' + JSON.generate({:name => content, :price => price}))
        end
      end

      #한식
      target = @parsed_data[1].css('table.line00 tr')[3].css('table')[1].css('tr')
      
      (1..8).each do |i|
        content = target[i].css('td')[2].text.gsub("\r","").gsub("\t","").gsub("\n","")
        price = target[i].css('td')[3].text
        if eachmenus == ""
          #첫 번째 메뉴면, 콤마없이
          eachmenus += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          eachmenus += (',' + JSON.generate({:name => content, :price => price}))
        end
      end

      #철판
      target = @parsed_data[2].css('table.line00 tr')[3].css('table')[1].css('tr')
      
      (1..11).each do |i|
        content = target[i].css('td')[2].text.gsub("\r","").gsub("\t","").gsub("\n","")
        price = target[i].css('td')[3].text
        if eachmenus == ""
          #첫 번째 메뉴면, 콤마없이
          eachmenus += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          eachmenus += (',' + JSON.generate({:name => content, :price => price}))
        end
      end

      #일식
      target = @parsed_data[3].css('table.line00 tr')[3].css('table')[1].css('tr')
      
      (1..13).each do |i|
        content = target[i].css('td')[2].text.gsub("\r","").gsub("\t","").gsub("\n","")
        price = target[i].css('td')[3].text
        if eachmenus == ""
          #첫 번째 메뉴면, 콤마없이
          eachmenus += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          eachmenus += (',' + JSON.generate({:name => content, :price => price}))
        end
      end

      #쌀국수
      target = @parsed_data[4].css('table.line00 tr')[3].css('table')[1].css('tr')
      
      (1..5).each do |i|
        content = target[i].css('td')[2].text.gsub("\r","").gsub("\t","").gsub("\n","")
        price = target[i].css('td')[3].text
        if eachmenus == ""
          #첫 번째 메뉴면, 콤마없이
          eachmenus += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          eachmenus += (',' + JSON.generate({:name => content, :price => price}))
        end
      end

      #요리부 (여기만 table[0])
      target = @parsed_data[5].css('table.line00 tr')[3].css('table')[0].css('tr')
      
      (1..15).each do |i|
        if target[i].css('td').text.empty?
          next
        end
        content = target[i].css('td')[2].text.gsub("\r","").gsub("\t","").gsub("\n","")
        price = target[i].css('td')[3].text
        if eachmenus == ""
          #첫 번째 메뉴면, 콤마없이
          eachmenus += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          eachmenus += (',' + JSON.generate({:name => content, :price => price}))
        end
      end

      Diet.create(
        :univ_id => 8,
        :name => "푸드코트",
        :location => "동해문화예술관 지하 1F",
        :date => @default_dates[currentDate],
        :time => 'breakfast',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
      Diet.create(
        :univ_id => 8,
        :name => "푸드코트",
        :location => "동해문화예술관 지하 1F",
        :date => @default_dates[currentDate],
        :time => 'lunch',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
      Diet.create(
        :univ_id => 8,
        :name => "푸드코트",
        :location => "동해문화예술관 지하 1F",
        :date => @default_dates[currentDate],
        :time => 'dinner',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
    end

  end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
