#한양대학교
class Hanyang
	def initialize
	    @default_dates = Array.new
	end

	def scrape
		#학생식당
		hanyang_erica_url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=2"
		hanyang_erica_data = Nokogiri::HTML(open(hanyang_erica_url))

		#Mon to Sun
		(0..6).each do |i|  #일요일까지 있는 경우도 있음.
			@default_dates << ((Date.parse hanyang_erica_data.css('h3.h3Campus03').text.strip.split('(')[1].split(' ')[0]) + i).to_s
	  end

	  #학생 식당
	  target = hanyang_erica_data.css('div#sikdang table')

	  content = ""
	  i = 0 #날짜별 즉, 테이블
		menu = ""

		target.each do |t|
	    p = 0 #각 메뉴별 즉, <td>
			t.css('td').each do |part|
	      if (part.nil? || part.text == " ")
	        #Do nothing
        elsif (part.text == "중식")
          #Do nothing
        elsif (p % 2 == 1)  #홀수
					if part.text != " "
          	content = part.text
          else
          end
        elsif (p % 2 == 0) #짝수
					if part.text != " "
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
          #Do nothing
        end
        p += 1
      end

			if menu != ""
        Diet.create(
          :univ_id => 01,
          :name => "(에리카)학생식당",
          :location => "복지관2층",
          :date => @default_dates[i],
          :time => 'lunch',
          :diet => menu,
          :extra => nil
          )
      end
      menu = ""
      i += 1

			#금요일까지 했으면 끝
			if (i == 5)
        break
      else
      end

    end

		#창의인재원식당
		hanyang_erica_url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=3"
		hanyang_erica_data = Nokogiri::HTML(open(hanyang_erica_url))

    target = hanyang_erica_data.css('div#sikdang table')

    content = ""
    time = ""
    i=0
    checkfirst=0
		menu = ""

    target.each do |t|	#each tables
			if i == 7
    		break
    	end

    	t.css('tr').each do |part1|	#each <tr>
				if checkfirst == 0
    			checkfirst = 1
    			next
    		else
    			#Do nothing
    		end
    		p=0
    		part1.css('td').each do |part2|	#each <td>
					if (part2.text == "조식")
	          time = 'breakfast'
						menu = ""
	        elsif (part2.text == "중식")
						if menu != ""
              Diet.create(
                :univ_id => 01,
                :name => "(에리카)창의인재원식당",
                :location => "창의관1층",
                :date => @default_dates[i],
                :time => time,
                :diet => menu,
                :extra => nil
                )
            end
	          time = 'lunch'
						menu = ""
	        elsif (part2.text == "석식")
	          if menu != ""
              Diet.create(
                :univ_id => 01,
                :name => "(에리카)창의인재원식당",
                :location => "창의관1층",
                :date => @default_dates[i],
                :time => time,
                :diet => menu,
                :extra => nil
                )
            end
	          time = 'dinner'
            menu = ""
	        elsif (p % 2 == 1)  #홀수
							content = part2.text
	        elsif (p % 2 == 0) #짝수
						price = part2.text.scan(/\d/).join('')
	        	if (content == " " || content == "  ")
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
	        end
					p += 1
    		end
				if menu != ""
          Diet.create(
            :univ_id => 01,
            :name => "(에리카)창의인재원식당",
            :location => "창의관1층",
            :date => @default_dates[i],
            :time => time,
            :diet => menu,
            :extra => nil
            )
        end
        time = 'breakfast'
        menu = ""
    	end
    	i += 1
    end


		#교직원 식당
		hanyang_erica_url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=1"
	  hanyang_erica_data = Nokogiri::HTML(open(hanyang_erica_url))

	  target = hanyang_erica_data.css('div#sikdang table')

	  content = ""
    time = ""
    i=0
    checkfirst=0
		menu = ""

    target.each do |t|	#each tables
			if i == 5
    		break
    	end

    	t.css('tr').each do |part1|	#each <tr>
				if checkfirst == 0
    			checkfirst = 1
    			next
    		else
    			#Do nothing
    		end
    		p=0
    		part1.css('td').each do |part2|	#each <td>
	        if (part2.text == "중식")	#From here time is lunch
	          time = 'lunch'
						menu = ""
	        elsif (part2.text == "석식")	#From here time is dinner
	        	#Before start dinner insert into diet value "lunchs."
	        	if menu != ""
            Diet.create(
              :univ_id => 01,
              :name => "(에리카)교직원식당",
              :location => "복지관3층",
              :date => @default_dates[i],
              :time => time,
              :diet => menu,
              :extra => nil #NULL
              )
            end
	          time = 'dinner'
            menu = ""
					elsif (p % 2 == 1)  #홀수
						content = part2.text
	        elsif (p % 2 == 0) #짝수
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
	        p += 1
    		end

				#Before start next table insert into diet value "dinners."
				if menu != ""
          Diet.create(
            :univ_id => 01,
            :name => "(에리카)교직원식당",
            :location => "복지관3층",
            :date => @default_dates[i],
            :time => time,
            :diet => menu,
            :extra => nil #NULL
            )
        end
        time = 'lunch'
        menu = ""
    	end
    	i += 1
    end

		#창업보육센터
		hanyang_erica_url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=5"
	  hanyang_erica_data = Nokogiri::HTML(open(hanyang_erica_url))

    target = hanyang_erica_data.css('div#sikdang table')
    content = ""
    price = ""
    time = ""
    i = 0
		menu = ""

    target.each do |t|
      t.css('td').each do |part|
        if (part.nil? || part.text == " ")
          #Do nothing
        elsif (part.text == "중식")
          time = 'lunch'
        elsif (part.text == "석식")
					if menu != ""
            Diet.create(
              :univ_id => 01,
              :name => "(에리카)창업보육센터",
              :location => "창업보육센터 지하1층",
              :date => @default_dates[i],
              :time => time,
              :diet => menu,
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
          if content == " "	#content에 문제가 있으면 생성 x
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
      end

			if menu != ""
        Diet.create(
          :univ_id => 01,
          :name => "(에리카)창업보육센터",
          :location => "창업보육센터 지하1층",
          :date => @default_dates[i],
          :time => time,
          :diet => menu,
          :extra => nil
          )
      end
      time = 'lunch'
      menu = ""
      i += 1
	      
	    #금요일까지 하고 끝
	    if (i == 5)
        break
      else
      end
    end

    #마인드 푸드코트
    hanyang_erica_url = "https://www.hanyang.ac.kr/upmu/sikdan/sikdan_View.jsp?gb=2&code=4"
	  hanyang_erica_data = Nokogiri::HTML(open(hanyang_erica_url))

		target = hanyang_erica_data.css('div#sikdang table')
    price = ""
    content = ""
    i = 0
    menu = ""

		target.each do |t|
      t.css('td').each do |part|
        if (part.nil? || part.text.strip == " ")
          #Do nothing
        elsif (part.text == "한식")
          #Do nothing
        elsif (part.text == "양식")
        	if menu != ""
          Diet.create(
            :univ_id => 01,
            :name => "(에리카)마인드 푸드코트(한식)",
            :location => "복지관 3층",
            :date => @default_dates[i],
            :time => 'breakfast',
            :diet => menu,
            :extra => nil
            )
          end
          menu = ""
				elsif (part.text == "분식")
        	if menu != ""
          Diet.create(
            :univ_id => 01,
            :name => "(에리카)마인드 푸드코트(양식)",
            :location => "복지관 3층",
            :date => @default_dates[i],
            :time => 'breakfast',
            :diet => menu,
            :extra => nil
            )
          end
          menu = ""
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
          :univ_id => 01,
          :name => "(에리카)마인드 푸드코트(분식)",
          :location => "복지관 3층",
          :date => @default_dates[i],
          :time => 'breakfast',
          :diet => menu,
          :extra => nil
          )
      end
      menu = ""
      i += 1 
	 
	    #금요일까지 하고 끝
	    if (i == 5)
        break
      else
      end
    end

	end	#scrape
end	#class
