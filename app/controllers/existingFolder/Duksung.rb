#덕성여자대학교
class Duksung
  def initialize
    
    #URL
    @duksung_url = "http://www.duksung.ac.kr/life/foodmenu/index.jsp"
    #Parsing to <HTML> with Nokogiri
    @duksung_data = Nokogiri::HTML(open(@duksung_url))
		
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

    #교직원 식당
    target = @duksung_data.css('table.menu-table tbody tr')[0].css('td')
    i = 0
    target.each do |t| 
      if t.text[0] != '-'
        if t.text.strip.gsub("\n","").gsub("\r",",").empty?
          break
        else
          Diet.create(
            :univ_id => 110,
            :name => "교직원식",
            :location => "학생회관2층",
            :date => @default_dates[i],
            :time => 'lunch',
            :diet => JSON.generate({:name => t.text.strip.gsub("\n","").gsub("\r",","), :price => ''}),
            :extra => nil
            )
        end
      else
        next
      end
      i += 1
    end

		#학생 식당
		target = @duksung_data.css('table.menu-table tbody tr')[1].css('td')
    i = 0
    target.each do |t|
      if t.text[0] != '-'
        Diet.create(
          :univ_id => 110,
          :name => "학생식",
          :location => "학생회관2층",
          :date => @default_dates[i],
          :time => 'lunch',
          :diet => JSON.generate({:name => t.text.strip.split("\r\r")[0].gsub("\n","").gsub("\r",",").gsub("*중식*,",""), :price => ''}),
          :extra => nil
          )
					if t.text.strip.split("\r\r")[1].nil?
          	#Do nothing
        	else
						Diet.create(
            	:univ_id => 110,
            	:name => "학생식",
            	:location => "학생회관2층",
            	:date => @default_dates[i],
            	:time => 'dinner',
            	:diet => JSON.generate({:name => t.text.strip.split("\r\r")[1].gsub("\n","").gsub("\r",",").gsub("*석식*,",""), :price => ''}),
            	:extra => nil
            )
					end
      else
        next
      end
      i += 1
    end

  end

end
