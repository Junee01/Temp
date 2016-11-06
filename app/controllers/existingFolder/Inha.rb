#인하대학교
class Inha
	def initialize
		@default_dates = Array.new
	end
	def scrape

		#인하대학교
		inha_url = "http://www.inha.ac.kr/user/restaurantMenList.do?handle=2&siteId=kr&id=kr_060301000000"
	  inha_data = Nokogiri::HTML(open(inha_url))

		#Mon to Fri
	  (0..4).each do |i|
	    @default_dates << ((Date.parse inha_data.css('div.tbl_day_control th').text.split('(')[0]) + i).to_s
	  end

		#학생 식당(조식)
		target = inha_data.css('div.tbl_food_list')
	  i=0

		target.each do |tar|

			#소반
			content = ""
	    tmp = tar.css('tbody tr')[0].css('td.left p')

	    if tmp.empty? || (tmp.text == "")
	      #Do nothing
	    else
				tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ','
	      end
				
				content = content.gsub("\t","")	#인하대학교는 <여름을 부탁해!> 같은 타이틀을 사용할 때, \t를 많이 써서... 만약을 대비
				price = tar.css('tbody tr')[0].css('td')[1].text.scan(/\d/).join('')

	      Diet.create(
	        :univ_id => 171,
	        :name => "소반",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'breakfast',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	      )
	    end

			#스낵
			content = tar.css('tbody tr')[1].css('td')[0].text.strip.gsub("\r\n","").gsub("    ","")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[1].css('td')[1].text.strip.scan(/\d/).join('')

			#이건 그냥 스페이스가 아니다.
			if (content == " " || content == " ")
	      #Do nothing
	    else
	      Diet.create(
	        :univ_id => 171,
	        :name => "스낵",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'breakfast',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	      )
	    end

			#학생 식당(중식)
			#뚝배기
			content = ""
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

				Diet.create(
	        :univ_id => 171,
	        :name => "뚝배기",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'lunch',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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
	        
	      Diet.create(
	        :univ_id => 171,
	        :name => "명가",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'lunch',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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
	        
	      Diet.create(
	        :univ_id => 171,
	        :name => "누들",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'lunch',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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

	      Diet.create(
	        :univ_id => 171,
	        :name => "소반",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'lunch',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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

	      Diet.create(
	        :univ_id => 171,
	        :name => "돈까스",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'lunch',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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
	      Diet.create(
	        :univ_id => 171,
	        :name => "스낵1",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'lunch',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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
	        Diet.create(
	          :univ_id => 171,
	          :name => "스낵2",
	          :location => "학생식당",
	          :date => @default_dates[i],
	          :time => 'lunch',
	          :diet => JSON.generate({:name => content, :price => price}),
	          :extra => nil
	          )
	      end
	    end

			#학생식당(석식)
			#뚝배기
			content = ""
	    tmp = tar.css('tbody tr')[10].css('td.left p')

	    if tmp.empty?
	      #Do nothing
	    else
	      tmp.each do |t|
	        content += t.text.gsub("\r\n","").gsub("    ","") + ","
	      end
	      content = content.gsub("\t","")

	      price = tar.css('tbody tr')[10].css('td')[1].text.scan(/\d/).join('')

	      Diet.create(
	        :univ_id => 171,
	        :name => "뚝배기",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'dinner',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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

	      Diet.create(
	        :univ_id => 171,
	        :name => "명가",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'dinner',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
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

	      Diet.create(
	        :univ_id => 171,
	        :name => "소반",
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => 'dinner',
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
	    end
	    i += 1
	  end

		#교직원 시작 (교직원 식당은 학생 식당과 구조가 다르고 간단하다.)
		inha_url = "http://www.inha.ac.kr/user/restaurantMenList.do?handle=1&siteId=kr&id=kr_060302000000"
	  inha_data = Nokogiri::HTML(open(inha_url))

	  target = inha_data.css('div.tbl_food_list')
	  i=0

	  target.each do |tar|
			#백반
			content = tar.css('tbody tr')[0].css('td.left').text.strip.gsub("\t","").gsub("\r\n",",")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[0].css('td')[1].text.scan(/\d/).join('')

	    Diet.create(
	      :univ_id => 171,
	      :name => "백반(교직원)",
	      :location => "교직원식당",
	      :date => @default_dates[i],
	      :time => 'lunch',
	      :diet => JSON.generate({:name => content, :price => price}),
	      :extra => nil
	      )

			#특식
			content = tar.css('tbody tr')[1].css('td.left').text.strip.gsub("\t","").gsub("\r\n",",")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[1].css('td')[1].text.scan(/\d/).join('')

	    Diet.create(
	      :univ_id => 171,
	      :name => "특식(교직원)",
	      :location => "교직원식당",
	      :date => @default_dates[i],
	      :time => 'lunch',
	      :diet => JSON.generate({:name => content, :price => price}),
	      :extra => nil
	      )

			#석식
			content = tar.css('tbody tr')[2].css('td.left').text.strip.gsub("\t","").gsub("\r\n",",")
	    content = content.gsub("\t","")
	    price = tar.css('tbody tr')[2].css('td')[1].text.scan(/\d/).join('')

	    Diet.create(
	      :univ_id => 171,
	      :name => "석식(교직원)",
	      :location => "교직원식당",
	      :date => @default_dates[i],
	      :time => 'dinner',
	      :diet => JSON.generate({:name => content, :price => price}),
	      :extra => nil
	      )
	    i += 1
	  end

		#서호관 (가격이 없다.)
		inha_url = "http://www.inha.ac.kr/user/restaurantMenList.do?handle=3&siteId=kr&id=kr_060303000000"

	  inha_data = Nokogiri::HTML(open(inha_url))

	  target = inha_data.css('div.tbl_food_list')
	  i=0

		target.each do |tar|
			#중식
			content = ""
	    tmp = tar.css('tbody tr')[0].css('td.left p')
	    tmp.each do |t|
	      content += t.text + ","
	    end
	    content = content.gsub("\t","").gsub("\r\n","")

	    price = tar.css('tbody tr')[0].css('td')[1].text.strip

	    if content.empty? == false
		    Diet.create(
		      :univ_id => 171,
		      :name => "중식(서호관)",
		      :location => "서호관",
		      :date => @default_dates[i],
		      :time => 'lunch',
		      :diet => JSON.generate({:name => content, :price => price}),
		      :extra => nil
		      )
		  else
		  end

			#스낵
			content = ""
	    tmp = tar.css('tbody tr')[1].css('td.left p')
	    tmp.each do |t|
	      content += t.text + ","
	    end
	    content = content.gsub("\t","").gsub("\r\n","")

	    price = tar.css('tbody tr')[1].css('td')[1].text.strip

	    if content.empty? == false
		    Diet.create(
		      :univ_id => 171,
		      :name => "스낵(서호관)",
		      :location => "서호관",
		      :date => @default_dates[i],
		      :time => 'lunch',
		      :diet => JSON.generate({:name => content, :price => price}),
		      :extra => nil
		      )
		  else
		  end

			#석식
			content = ""
	    tmp = tar.css('tbody tr')[2].css('td.left p')
	    tmp.each do |t|
	      content += t.text + ","
	    end

			content = content.gsub("\t","").gsub("\r\n","")

	    price = tar.css('tbody tr')[2].css('td')[1].text.strip

			if content.empty? == false
		    Diet.create(
		      :univ_id => 171,
		      :name => "석식(서호관)",
		      :location => "서호관",
		      :date => @default_dates[i],
		      :time => 'dinner',
		      :diet => JSON.generate({:name => content, :price => price}),
		      :extra => nil
		      )
		  else
		  end
				
			i += 1
	  end
  end
end
