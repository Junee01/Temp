#동덕여자대학교
class Dongduk
  def initialize
    
    #URL
    @dongduk_url = "http://www.dongduk.ac.kr/front/cafeteria.do"
    #Parsing to <HTML> with Nokogiri
    @dongduk_data = Nokogiri::HTML(open(@dongduk_url))
   
		#억지로 today를 monday로 조절한다. 
		today = Date.today
		while (today.monday? == false)
	    today = today - 1
	  end

		#From mon to Fri
		@default_dates = Array.new
		d = 0
	  (0..4).each do |d|
	    @default_dates << ((Date.parse today.to_s) + d).to_s
	  end

  end

	def scrape

		#옛향 조식
		target = @dongduk_data.css('div.gradient')[0].css('tbody tr')[0].css('td')
    i = 0
    target.each do |t|
      if t.text.strip[0] != '옛' && t.text.strip[1] != '향'
        if t.text.strip.gsub("\n",",").empty?
          break
        else
          Diet.create(
            :univ_id => 112,
            :name => '옛향',
            :location => '학생식당',
            :date => @default_dates[i],
            :time => 'breakfast',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n",","), :price => "2,900"}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#옛향 중식
		target = @dongduk_data.css('div.gradient')[0].css('tbody tr')[1].css('td')
    i = 0
    target.each do |t|
      if t.text.strip[0] != '옛' && t.text.strip[1] != '향'
        if t.text.strip.gsub("\n",",").empty?
          break
        else
          Diet.create(
            :univ_id => 112,
            :name => '옛향',
            :location => '학생식당',
            :date => @default_dates[i],
            :time => 'lunch',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n",","), :price => "2,900"}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#옛향 석식
		target = @dongduk_data.css('div.gradient')[0].css('tbody tr')[2].css('td')
    i = 0
    target.each do |t|
      if t.text.strip[0] != '옛' && t.text.strip[1] != '향'
        if t.text.strip.gsub("\n",",").empty?
          break
        else
          Diet.create(
            :univ_id => 112,
            :name => '옛향',
            :location => '학생식당',
            :date => @default_dates[i],
            :time => 'dinner',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n",","), :price => "2,900"}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#참미소
		target = @dongduk_data.css('div.gradient')[0].css('tbody tr')[3].css('td')
    i = 0
    target.each do |t|
      if t.text.strip[0] != '참' && t.text.strip[1] != '미'
        if t.text.strip.gsub("\n",",").empty?
          break
        else
          Diet.create(
            :univ_id => 112,
            :name => '참미소',
            :location => '학생식당',
            :date => @default_dates[i],
            :time => 'breakfast',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n",","), :price => "1,000~3,400"}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#덮고볶고
		target = @dongduk_data.css('div.gradient')[0].css('tbody tr')[4].css('td')
    i = 0
    target.each do |t|
      if t.text.strip[0] != '덮' && t.text.strip[1] != '고'
        if t.text.strip.gsub("\n",",").empty?
          break
        else
          Diet.create(
            :univ_id => 112,
            :name => '덮고볶고',
            :location => '학생식당',
            :date => @default_dates[i],
            :time => 'breakfast',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n",","), :price => "3,400~3,600"}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#가스야
		target = @dongduk_data.css('div.gradient')[0].css('tbody tr')[5].css('td')
    i = 0
    target.each do |t|
      if t.text.strip[0] != '가' && t.text.strip[1] != '스'
        if t.text.strip.gsub("\n",",").empty?
          break
        else
          Diet.create(
            :univ_id => 112,
            :name => '가스야',
            :location => '학생식당',
            :date => @default_dates[i],
            :time => 'breakfast',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n",","), :price => "3,700~3,800"}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#교직원 식당이 아직 확인이 안됨 추후 추가 예정임.

  end

end
