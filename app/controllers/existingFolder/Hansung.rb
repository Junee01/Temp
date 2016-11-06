#한성대학교
class Hansung
	def initialize
		
		#URL
		@hansung_url = "http://www.hansung.ac.kr/web/www/life_03_01_t1"
	  #Parsing to <HTML> with Nokogiri
		@hansung_data = Nokogiri::HTML(open(@hansung_url))
		
		#Mon to Fri
		@default_dates = Array.new
	  (0..4).each do |i|
	    @default_dates << ((Date.parse @hansung_data.css('div.menu-wrap h4').text.strip.split(' ')[0]) + i).to_s
	  end

	end

	def scrape

		#학생 중식
		target = @hansung_data.css('tbody tr')[0].css('td')
	  i=0
	  (0..4).each do |t|
	  	if target[t].inner_html.strip != " "
		    Diet.create(
		      :univ_id => 555,
		      :name => "일품",
		      :location => "학생식당",
		      :date => @default_dates[i],
		      :time => 'lunch',
		      :diet => JSON.generate({:name => target[t].inner_html.strip.gsub("<br>",","), :price => @hansung_data.css('tbody tr th')[0].inner_html.split("<br>")[1].scan(/\d/).join('')}),
		      :extra => nil
		      )
	    else
	    end
	    i += 1
	  end

		#학생 석식
		target = @hansung_data.css('tbody tr')[2].css('td')
	  i=0
		#석식 부분에는 쓸데없이 <td>가 하나 더 추가되어 있어서 1~5
		(1..5).each do |t|
	    if target[t].inner_html.strip != " "
		    Diet.create(
		      :univ_id => 555,
		      :name => "일품",
		      :location => "학생식당",
		      :date => @default_dates[i],
		      :time => 'dinner',
		      :diet => JSON.generate({:name => target[t].inner_html.strip.gsub("<br>",","), :price => ""}),
		      :extra => nil
		      )
	    else
	    end
	    i += 1
	  end

		#교직원 부분 시작
		@hansung_url = "http://www.hansung.ac.kr/web/www/life_03_01_t2"

	  @hansung_data = Nokogiri::HTML(open(@hansung_url))

	  #교직원 중식
	  target = @hansung_data.css('tbody tr')[0].css('td')
	  i=0
	  (0..4).each do |t|
	    if target[t].inner_html.strip != " "
		    Diet.create(
		      :univ_id => 555,
		      :name => "중식",
		      :location => "교직원식당",
		      :date => @default_dates[i],
		      :time => 'lunch',
		      :diet => JSON.generate({:name => target[t].inner_html.strip.gsub("<br>",","), :price => ""}),
		      :extra => nil
		      )
		  else
		  end
	    i += 1
	  end

		#교직원 석식
		target = @hansung_data.css('tbody tr')[1].css('td')
	  i=0
	  (1..5).each do |t|
	    if target[t].inner_html.strip != " "
		    Diet.create(
		      :univ_id => 555,
		      :name => "석식",
		      :location => "교직원식당",
		      :date => @default_dates[i],
		      :time => 'dinner',
		      :diet => JSON.generate({:name => target[t].inner_html.strip.gsub("<br>",","), :price => ""}),
		      :extra => nil
		      )
		  else
		  end
	    i += 1
	  end

	end
end
