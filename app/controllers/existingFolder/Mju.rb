#명지대학교
class Mju
	def initialize
		@default_dates = Array.new
	end
	def scrape

	  mju_url = "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=3560&id=mjukr_051001030000"

	  mju_data = Nokogiri::HTML(open(mju_url))

	  #Mon to Sun
	  (0..6).each do |i|
	    @default_dates << ((Date.parse mju_data.css('div.cafeteria_container tbody')[0].css('tr')[8].text.strip.split("\n")[0]) + i).to_s
	  end

	  #학생 식당
	  target = mju_data.css('div.cafeteria_container tbody')[0].css('tr')[9].css('td table.sub')
	  i=0
	  target.each do |table|
	    table.css('tr').each do |t|
	      name = t.css('td')[0].text
	      content = t.css('td')[1].text.gsub("\t","").gsub("\n","").gsub("\r","")
	      price = ''

	      if t.css('td')[0].text[3..4] == "아침"
	        time = 'breakfast'
	      elsif t.css('td')[0].text[3..4] == "점심"
	        time = 'lunch'
	      elsif t.css('td')[0].text[3..4] == "저녁"
	        time = 'dinner'
	      else
	        time = 'breakfast'  #default
				end

	      if content == " "	#콘텐츠에 문제가 있으면 Skip
					next
	      end

	      Diet.create(
	        :univ_id => 25,
	        :name => name,
	        :location => "학생식당",
	        :date => @default_dates[i],
	        :time => time,
	        :diet => JSON.generate({:name => content, :price => price}),
	        :extra => nil
	        )
	    end
	    i += 1
	  end

		#교직원 식당
		mju_url = "https://www.mju.ac.kr/mbs/mjukr/jsp/restaurant/restaurant.jsp?configIdx=11619&id=mjukr_051001020000"

	  mju_data = Nokogiri::HTML(open(mju_url))

	  target = mju_data.css('div.cafeteria_container tbody')[0].css('tr')[9].css('td table.sub')
	  i=0
	  target.each do |table|
	    table.css('tbody tr').each do |t|
	      if t.css('td')[0].text[7..8] == "아침"
	        time = 'breakfast'
	      elsif t.css('td')[0].text[7..8] == "점심"
	        time = 'lunch'
	      elsif t.css('td')[0].text[7..8] == "저녁"
	        time = 'dinner'
	      else
	        time = 'breakfast'
	      end

	      if t.css('td')[1].css('p').empty?
	        next
	      else
	        #명지대학교는 쉬는 날은 중식에만 표시를 하는 듯 함. 그러므로 저녁은 예외처리
	        #수라상A
	        name = t.css('td')[1].css('p')[0].text.gsub("<","").split(">")[0]
	        content = t.css('td')[1].css('p')[0].text.gsub("<","").split(">")[1]
	        price = ''

	        if content == " "	#콘텐츠에 문제가 있으면 Skip
						next
	        end

					Diet.create(
	          :univ_id => 25,
	          :name => name,
	          :location => "교직원식당",
	          :date => @default_dates[i],
	          :time => time,
	          :diet => JSON.generate({:name => content, :price => price}),
	          :extra => nil
	          )

	        if t.css('td')[1].css('p')[3].nil?
	          next
					else		          
						#수라상B
		        name = t.css('td')[1].css('p')[3].text.gsub("<","").split(">")[0]
		        content = t.css('td')[1].css('p')[3].text.gsub("<","").split(">")[1]
		        price = ''

		        if content == " "	#콘텐츠에 문제가 있으면 Skip
							next
		        end

						Diet.create(
		          :univ_id => 25,
		          :name => name,
		          :location => "교직원식당",
		          :date => @default_dates[i],
		          :time => time,
		          :diet => JSON.generate({:name => content, :price => price}),
		          :extra => nil
		          )
	        end
	      end
	    end
	    i += 1
		end   
	end
end
