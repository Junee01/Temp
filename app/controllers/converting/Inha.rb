#인하대학교
class Inha
	#Initialize
	def initialize
		@default_dates = Array.new
		@url = "http://www.inha.ac.kr/user/restaurantMenList.do?handle=2&siteId=kr&id=kr_060301000000"
	  @parsed_data = Nokogiri::HTML(open(@url))

	  #Init Mon to Fri
	  (0..4).each do |i|
	    @default_dates << ((Date.parse @parsed_data.css('div.tbl_day_control th').text.split('(')[0]) + i).to_s
	  end
	end #Initialize end

	#Main method scraping
	def scrape
		
		target = @parsed_data.css('div.tbl_food_list')
	  currentDate=0
	  menu = ""

	  #한번의 Loop가 하루 target 시작
		target.each do |tar|

			#학생 식당(조식)
			#소반
			content = ""
			menu = ""
	    tmp = tar.css('tbody tr')[0].css('td.left p')

	    if tmp.empty? || (tmp.text == "")
	      #Do nothing
	    else
				tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ','
	      end
				
				content = content.gsub("\t","")	#인하대학교는 <여름을 부탁해!> 같은 타이틀을 사용할 때, \t를 많이 써서... 만약을 대비
				price = tar.css('tbody tr')[0].css('td')[1].text.scan(/\d/).join('')

				if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
        menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#스낵
			content = tar.css('tbody tr')[1].css('td')[0].text.strip.gsub("\r\n","").gsub("    ","")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[1].css('td')[1].text.strip.scan(/\d/).join('')

			#이건 그냥 스페이스가 아니다.
			if (content == " " || content == " ")
	      #Do nothing
	    else
	    	if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end

        Diet.create(
        :univ_id => 9,
        :name => "학생식당",
        :location => "학생회관 2층",
        :date => @default_dates[currentDate],
        :time => 'breakfast',
        :diet => ArrJson(menu),
        :extra => nil
        )
	    end #조식 끝

			#학생 식당(중식)
			#뚝배기
			content = ""
			menu = ""
	    tmp = tar.css('tbody tr')[2].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	      else
				tmp.each do |t|
	        content += t.text.gsub("\r\n\t\t\t\t\t\t","").gsub("\r\n","").gsub("    ","") + ','
	      end
	      content = content.gsub("\t","")

	      if tar.css('tbody tr')[2].css('td')[1].text.strip.split('/')[1].nil?
	        price = tar.css('tbody tr')[2].css('td')[1].text.strip.scan(/\d/).join('')
	      else
	        price = tar.css('tbody tr')[2].css('td')[1].text.strip.split('/')[0].scan(/\d/).join('') + "," + tar.css('tbody tr')[2].css('td')[1].text.strip.split('/')[1].scan(/\d/).join('')
	      end

	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end

	    end

			#명가
			content = ""
	    tmp = tar.css('tbody tr')[3].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ','
	      end
	      content = content.gsub("\t","")

	      if tar.css('tbody tr')[3].css('td')[1].text.strip.split('/')[1].nil?
	        price = tar.css('tbody tr')[3].css('td')[1].text.scan(/\d/).join('')
	      else
	        price = tar.css('tbody tr')[3].css('td')[1].text.strip.split('/')[0].scan(/\d/).join('') + "," + tar.css('tbody tr')[3].css('td')[1].text.strip.split('/')[1].scan(/\d/).join('')
	      end
	        
	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
         menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#누들
			content = ""
	    tmp = tar.css('tbody tr')[4].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","") + ','
	      end
	      content = content.gsub("\t","")

	      if tar.css('tbody tr')[4].css('td')[1].text.strip.split('/')[1].nil?
	        tar.css('tbody tr')[4].css('td')[1].text.scan(/\d/).join('')
	      else
	        price = tar.css('tbody tr')[4].css('td')[1].text.strip.split('/')[0].scan(/\d/).join('') + "," + tar.css('tbody tr')[4].css('td')[1].text.strip.split('/')[1].scan(/\d/).join('')
	      end
	        
	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#소반
			content = ""
	    tmp = tar.css('tbody tr')[5].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","") + ','
	      end
	      content = content.gsub("\t","")

	      price = tar.css('tbody tr')[5].css('td')[1].text.scan(/\d/).join('')

	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
        	menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#돈까스
			content = ""
	    tmp = tar.css('tbody tr')[6].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	      	content += t.text.gsub("\r\n","") + ','
	      end
	      content = content.gsub("\t","")

	      price = tar.css('tbody tr')[6].css('td')[1].text.scan(/\d/).join('')

	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
        menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#스잭1
			content = ""
	    tmp = tar.css('tbody tr')[8].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.strip.gsub("■",",").gsub(" \\","/")
	      end
	      content = content.gsub("\t","")

	      price = target[0].css('tbody tr')[8].css('td')[1].text.scan(/\d/).join('')
	      
	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
        	menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
        	menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#스낵2
			content = ""
	    tmp = tar.css('tbody tr')[9].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text + ','
	      end
	      content = content.gsub("\t","")
	      price = tar.css('tbody tr')[9].css('td')[1].text.scan(/\d/).join('')
	      if tmp.empty?
	        #Do nothing
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

			if menu != ""
		    Diet.create(
	        :univ_id => 9,
	        :name => "학생식당",
	        :location => "학생회관 2층",
	        :date => @default_dates[currentDate],
	        :time => 'lunch',
	        :diet => ArrJson(menu),
	        :extra => nil
	        )
	  	end #중식 끝

			#학생식당(석식)
			#뚝배기
			content = ""
			menu = ""
	    tmp = tar.css('tbody tr')[10].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ","
	      end
	      content = content.gsub("\t","")

	      price = tar.css('tbody tr')[10].css('td')[1].text.scan(/\d/).join('')

	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#명가
			content = ""
	    tmp = tar.css('tbody tr')[11].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ","
	      end
	      content = content.gsub("\t","")

	      price = tar.css('tbody tr')[11].css('td')[1].text.scan(/\d/).join('')

	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

			#소반
			content = ""
	    tmp = tar.css('tbody tr')[12].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ","
	      end
	      content = content.gsub("\t","")

	      price = tar.css('tbody tr')[12].css('td')[1].text.scan(/\d/).join('')

	      if menu == ""
          #첫 번째 메뉴면, 콤마없이
          menu += JSON.generate({:name => content, :price => price})
        else
          #하나 이상 메뉴면 콤마 추가
          menu += (',' + JSON.generate({:name => content, :price => price}))
        end
	    end

	    if menu != ""
		    Diet.create(
		      :univ_id => 9,
		      :name => "학생식당",
		      :location => "학생회관 2층",
		      :date => @default_dates[currentDate],
		      :time => 'dinner',
		      :diet => ArrJson(menu),
		      :extra => nil
		      )
		  end	#석식 끝

			currentDate += 1 #다음 날짜로 넘어감.
		end	#target 끝, 학생식당 끝

		#(교직원 식당은 학생 식당과 구조가 다르고 간단하다.)
		@url = "http://www.inha.ac.kr/user/restaurantMenList.do?handle=1&siteId=kr&id=kr_060302000000"
	  @parsed_data = Nokogiri::HTML(open(@url))
	  currentDate=0
	  menu = ""
	  
	  target = @parsed_data.css('div.tbl_food_list')
	  target.each do |tar|
	  	#중식
	  	#백반
	  	content = tar.css('tbody tr')[0].css('td.left').text.strip.gsub("\t","").gsub("\r\n",",")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[0].css('td')[1].text.scan(/\d/).join('')

	    if menu == ""
        #첫 번째 메뉴면, 콤마없이
        menu += JSON.generate({:name => content, :price => price})
      else
        #하나 이상 메뉴면 콤마 추가
      	menu += (',' + JSON.generate({:name => content, :price => price}))
      end

			#특식
			content = tar.css('tbody tr')[1].css('td.left').text.strip.gsub("\t","").gsub("\r\n",",")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[1].css('td')[1].text.scan(/\d/).join('')

	    if menu == ""
        #첫 번째 메뉴면, 콤마없이
        menu += JSON.generate({:name => content, :price => price})
      else
        #하나 이상 메뉴면 콤마 추가
        menu += (',' + JSON.generate({:name => content, :price => price}))
      end

      if menu != ""
      	Diet.create(
		      :univ_id => 9,
		      :name => "교직원식당",
		      :location => "본관 지하",
		      :date => @default_dates[currentDate],
		      :time => 'lunch',
		      :diet => ArrJson(menu),
		      :extra => nil
		      )
      end #중식 끝

			#석식
			content = tar.css('tbody tr')[2].css('td.left').text.strip.gsub("\t","").gsub("\r\n",",")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[2].css('td')[1].text.scan(/\d/).join('')
	    menu = ""

	    if menu == ""
        #첫 번째 메뉴면, 콤마없이
        menu += JSON.generate({:name => content, :price => price})
      else
        #하나 이상 메뉴면 콤마 추가
        menu += (',' + JSON.generate({:name => content, :price => price}))
      end
      if menu != ""
      	Diet.create(
		      :univ_id => 9,
		      :name => "교직원식당",
		      :location => "본관 지하",
		      :date => @default_dates[currentDate],
		      :time => 'dinner',
		      :diet => ArrJson(menu),
		      :extra => nil
		      )
      end
      menu = ""
	    
	    currentDate += 1
	  end	#교직원 끝

		#서호관 (가격이 없다.)
		@url = "http://www.inha.ac.kr/user/restaurantMenList.do?handle=3&siteId=kr&id=kr_060303000000"
	  @parsed_data = Nokogiri::HTML(open(@url))
	  currentDate = 0
	  menu = ""

	  target = @parsed_data.css('div.tbl_food_list')
		target.each do |tar|
			#중식
			content = ""
	    tmp = tar.css('tbody tr')[0].css('td.left p')
	    tmp.each do |t|
	      content += t.text + ","
	    end
	    content = content.gsub("\t","").gsub("\r\n","").gsub(" ","")

	    price = tar.css('tbody tr')[0].css('td')[1].text.strip

	    if content.empty? == false
	    	if menu == ""
	        #첫 번째 메뉴면, 콤마없이
	        menu += JSON.generate({:name => content, :price => price})
	      else
	        #하나 이상 메뉴면 콤마 추가
	        menu += (',' + JSON.generate({:name => content, :price => price}))
	      end
		  end

			#스낵
			content = ""
	    tmp = tar.css('tbody tr')[1].css('td.left p')
	    tmp.each do |t|
	      content += t.text + ","
	    end
	    content = content.gsub("\t","").gsub("\r\n","").gsub(" ","")

	    price = tar.css('tbody tr')[1].css('td')[1].text.strip

	    if content.empty? == false
		    if menu == ""
	        #첫 번째 메뉴면, 콤마없이
	        menu += JSON.generate({:name => content, :price => price})
	      else
	        #하나 이상 메뉴면 콤마 추가
	        menu += (',' + JSON.generate({:name => content, :price => price}))
	      end
		  end

		  if menu != ""
		  	Diet.create(
		      :univ_id => 9,
		      :name => "서호관",
		      :location => "서호관 1층",
		      :date => @default_dates[currentDate],
		      :time => 'lunch',
		      :diet => ArrJson(menu),
		      :extra => nil
		      )
		  end #중식 끝

			#석식
			content = ""
			menu = ""
	    tmp = tar.css('tbody tr')[2].css('td.left p')
	    tmp.each do |t|
	      content += t.text + ","
	    end

			content = content.gsub("\t","").gsub("\r\n","").gsub(" ","")

	    price = tar.css('tbody tr')[2].css('td')[1].text.strip

			if content.empty? == false
		    if menu == ""
	        #첫 번째 메뉴면, 콤마없이
	        menu += JSON.generate({:name => content, :price => price})
	      else
	        #하나 이상 메뉴면 콤마 추가
	        menu += (',' + JSON.generate({:name => content, :price => price}))
	      end
		  end

		  if menu != ""
		  	Diet.create(
		      :univ_id => 9,
		      :name => "서호관",
		      :location => "서호관 1층",
		      :date => @default_dates[currentDate],
		      :time => 'dinner',
		      :diet => ArrJson(menu),
		      :extra => nil
		      )
		  end #석식 끝

			menu = ""
				
			currentDate += 1 #다음 날짜로 넘어감
		end	#서호관 끝

	
  end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
