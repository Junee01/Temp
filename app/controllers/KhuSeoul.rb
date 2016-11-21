#경희대학교 서울캠퍼스(802) 2016-11-18 처음 구현한 부분입니다.
class KhuSeoul
  #Initialize
  def initialize
  	@url = "http://coop.khu.ac.kr/"  #경희대학교 생활협동조합(서울 캠퍼스)
 	 	@parsed_data = Nokogiri::HTML(open(@url))
  	@default_date = Date.today.to_s #오늘의 날짜(경희대학교 생협은 당일의 식단만 공개를 하고 있다. 그러므로 오늘의 날짜만 사용한다.)
  end
  #Initialize end

  #Main method scraping
	def scrape
    breakfasts = ''
    lunchs = ''

    target0 = @parsed_data.css('div#tabs0 table tbody tr') #청운관(생협) 학생
    restaurantName = "청운관(생협) 학생"

    target0.each do |i|
      if i.text.strip[0..3] == "문의전화"
        break
      else
        if i.css('td')[1].text.strip == "조식"
          if breakfasts == ''
            breakfasts = JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          else
            breakfasts += ',' + JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          end
        else
          if lunchs == ''
            lunchs = JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          else
            lunchs += ',' + JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          end
        end
      end
    end

		if breakfasts.empty? == false
			Diet.create(
      	:univ_id => 802,
      	:name => restaurantName,
      	:location => "청운관 지하 2층",
      	:date => @default_date,
      	:time => 'breakfast',
      	:diet => ArrJson(breakfasts),
      	:extra => ''
      	)
		end

		if lunchs.empty? == false
    	Diet.create(
      	:univ_id => 802,
      	:name => restaurantName,
      	:location => "청운관 지하 2층",
      	:date => @default_date,
      	:time => 'lunch',
      	:diet => ArrJson(lunchs),
      	:extra => ''
      	)
		end

    breakfasts = ''
    lunchs = ''

		target1 = @parsed_data.css('div#tabs1 table tbody tr')  #청운관(생협) 교직원
    restaurantName = "청운관(생협) 교직원"

    target1.each do |i|
      if i.text.strip[0..3] == "문의전화"
        break
      else
        if lunchs == ''
          lunchs = JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
        else
          lunchs += ',' + JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
        end
      end
    end

		if lunchs.empty? == false
			Diet.create(
      	:univ_id => 802,
      	:name => restaurantName,
      	:location => "청운관 지하 2층",
      	:date => @default_date,
      	:time => 'lunch',
      	:diet => ArrJson(lunchs),
      	:extra => ''
      	)
		end

    breakfasts = ''
    lunchs = ''
    dinners = ''

    target2 = @parsed_data.css('div#tabs2 table tbody tr') #푸른솔 학생
    restaurantName = "푸른솔 학생"

		target2.each do |i|
      if i.text.strip[0..3] == "문의전화"
        break
      else
        if i.css('td')[1].text.strip == "중식"
          if lunchs == ''
            lunchs = JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          else
            lunchs += ',' + JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          end
        else
          if dinners == ''
            dinners = JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          else
            dinners += ',' + JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
          end
        end
      end
    end

		if lunchs.empty? == false
			Diet.create(
      	:univ_id => 802,
      	:name => restaurantName,
      	:location => "푸른솔문화회관 1층",
      	:date => @default_date,
      	:time => 'lunch',
      	:diet => ArrJson(lunchs),
      	:extra => ''
      	)
		end

		if dinners.empty? == false
    	Diet.create(
      	:univ_id => 802,
      	:name => restaurantName,
      	:location => "푸른솔문화회관 1층",
      	:date => @default_date,
      	:time => 'dinner',
      	:diet => ArrJson(dinners),
      	:extra => ''
      	)
		end
		breakfasts = ''
    lunchs = ''
    dinners = ''

    target3 = @parsed_data.css('div#tabs3 table tbody tr') #푸른솔 교직원
    restaurantName = "푸른솔 교직원"

    target3.each do |i|
      if i.text.strip[0..3] == "문의전화"
        break
      else
        if lunchs == ''
          lunchs = JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
        else
          lunchs += ',' + JSON.generate({:name => i.css('td')[2].text.strip, :price => i.css('td')[4].text.strip})
        end
      end
    end

		if lunchs.empty? == false
			Diet.create(
      	:univ_id => 802,
      	:name => restaurantName,
      	:location => "푸른솔문화회관 1층",
      	:date => @default_date,
      	:time => 'lunch',
      	:diet => ArrJson(lunchs),
      	:extra => ''
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
