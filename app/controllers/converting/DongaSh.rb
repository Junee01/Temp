#동아대학교 승학 캠퍼스
class DongaSh
	#Initialize
	def initialize
		#URL, Dates
		@default_dates = Array.new
	  @urls = Array.new

	  today = Date.today
    while (today.monday? == false)
    	today = today - 1
    end

    (0..4).each do |i|
      @default_dates << ((Date.parse today.to_s) + i).to_s
      @urls << "http://www.donga.ac.kr/MM_PAGE/SUB007/SUB_007005005.asp?PageCD=007005005&seldate=" + @default_dates[i] + "#st"
    end
	end #Initialize end

	#Main method scraping
	def scrape
		names = Array.new
		contents = Array.new
		eachmenus = ''
		time = ''
		price = ''
		
		#Mon ~ Fri
		(0..4).each do |day|
      parsed_data = Nokogiri::HTML(open(@urls[day]))
      target = parsed_data.css('table.sk01TBL')[1]

      #Store names
      target.css('tr p').each do |tmp|
        if (tmp.text == "승학 캠퍼스" || tmp.text == " ")
          next
        else
          names << tmp.text
        end
      end

      #Store contents
      target.css('tr')[9].css('td.sk01TD').each do |tmp|
        if tmp.text.strip == " "
          next
        else
          contents << tmp.text.strip.gsub("\n\n","\n").gsub("\n\n","\n").gsub("\n",",")
        end
      end

      #Breakfast ~ Dinner
      (0..3).each do |part|
      	
      	if contents[part] == " "	#콘텐츠에 문제가 있으면 Skip
					next
        end

        #교수회관
        if names[part] == "교수회관"
        	eachmenus = JSON.generate({:name => contents[part], :price => price})
        	Diet.create(
	          :univ_id => 6,
	          :name => names[part],
	          :location => '',
	          :date => @default_dates[day],
	          :time => 'lunch',
	          :diet => ArrJson(eachmenus),
	          :extra => nil
		        )
        	Diet.create(
	          :univ_id => 6,
	          :name => names[part],
	          :location => '',
	          :date => @default_dates[day],
	          :time => 'dinner',
	          :diet => ArrJson(eachmenus),
	          :extra => nil
		        )
        end

				#학생회관, 도서관
				if names[part] == "학생회관" || names[part] == "도서관"
        	eachmenus = JSON.generate({:name => contents[part], :price => price})
        	Diet.create(
	          :univ_id => 6,
	          :name => names[part],
	          :location => '',
	          :date => @default_dates[day],
	          :time => 'breakfast',
	          :diet => ArrJson(eachmenus),
	          :extra => nil
	        	)
        	Diet.create(
	          :univ_id => 6,
	          :name => names[part],
	          :location => '',
	          :date => @default_dates[day],
	          :time => 'lunch',
	          :diet => ArrJson(eachmenus),
	          :extra => nil
	        	)
        	Diet.create(
	          :univ_id => 6,
	          :name => names[part],
	          :location => '',
	          :date => @default_dates[day],
	          :time => 'dinner',
	          :diet => ArrJson(eachmenus),
	          :extra => nil
	        	)
        end
      end #Breakfast ~ Dinner end
		end	#Mon ~ Fri end
	end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end	#Class end
