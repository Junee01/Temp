#동아대학교
class Donga
	def initialize
			@default_dates = Array.new
			@donga01_urls = Array.new
			@donga02_urls = Array.new
	end
		
	def scrape
		#동아 대학교는 6월 6일에는 해당일 식단을 업데이트 하지 않았습니다. 언제 업데이트를 하는지 기준이 모호합니다.
		#동아 대학교 승학 캠퍼스
			
		#억지로 today를 monday로 조절한다.
		today = Date.today
		while (today.monday? == false)
	    today = today - 1
	  end

	  (0..4).each do |i|
	    @default_dates << ((Date.parse today.to_s) + i).to_s
	    @donga01_urls << "http://www.donga.ac.kr/MM_PAGE/SUB007/SUB_007005005.asp?PageCD=007005005&seldate=" + @default_dates[i] + "#st"
	    @donga02_urls << "http://www.donga.ac.kr/MM_PAGE/SUB007/SUB_007005005.asp?PageCD=007005005&seldate=" + @default_dates[i] + "#st"
	  end

		(0..4).each do |day|
	    donga01_data = Nokogiri::HTML(open(@donga01_urls[day]))
	      
	    target = donga01_data.css('table.sk01TBL')[1]

	    names = Array.new
	    target.css('tr p').each do |tmp|
	      if (tmp.text == "승학 캠퍼스" || tmp.text == " ")
	        next
	      else
	        names << tmp.text
	      end
	    end

			contents = Array.new
	    target.css('tr')[9].css('td.sk01TD').each do |tmp|
	      if tmp.text.strip == " "
	        next
	      else
	        contents << tmp.text.strip.gsub("\n\n","\n").gsub("\n\n","\n").gsub("\n",",")
	      end
	    end

			content = ""
	    time = ""
	    price = ""

	    (0..3).each do |part|
				if contents[part] == " "	#콘텐츠에 문제가 있으면 Skip
				  next
	      end

	      Diet.create(
	        :univ_id => 267,
	        :name => names[part],
	        :location => names[part],
	        :date => @default_dates[day],
	        :time => 'breakfast',
	        :diet => JSON.generate({:name => contents[part], :price => price}),
	        :extra => nil
	        )
	    end
	  end

		#동아대학교 구덕/부민 캠퍼스
			
		(0..4).each do |day|
	    donga02_data = Nokogiri::HTML(open(@donga02_urls[day]))
	      
	    target = donga02_data.css('table.sk01TBL')[1]

	    names = Array.new
	    (10..14).each do |i|
	      names << target.css('td.sk01TD')[i].text.strip
	    end
	    names << target.css('td.sk02TD')[5].text.strip

	    contents = Array.new
	    (15..19).each do |i|
	      contents << target.css('td.sk01TD')[i].text.strip.gsub("\n\n","\n").gsub("\n\n","\n").gsub("\n",",")
	    end
	    contents << target.css('td.sk02TD')[6].text.strip.gsub("\n\n","\n").gsub("\n\n","\n").gsub("\n",",")

	    (0..5).each do |part|
				if contents[part] == " "	#콘텐츠에 문제가 있으면 Skip
					next
	      end

	      Diet.create(
	        :univ_id => 267,
	        :name => names[part],
	        :location => names[part],
	        :date => @default_dates[day],
	        :time => 'breakfast',
	        :diet => JSON.generate({:name => contents[part], :price => ""}),
	        :extra => nil
	        )
	    end
	  end
	end
end
