#광운대학교
class Kw
	def initialize
		@default_dates = Array.new
	end
	def scrape

		@kw_url = "http://www.kw.ac.kr/sub/life/uniguide18_1CP.do"

    @kw_data = Nokogiri::HTML(open(@kw_url))

		#Mon to Sun
		(0..4).each do |i|
      @default_dates << ((Date.parse @kw_data.css('div.search_day').text[0..9]) + i).to_s
    end

    #광운대학교는 조중식이라는 개념으로 제공중

		#조중식
		target = @kw_data.css('div.menu_table tr')[2].css('td')
    i = 0
    content = ""
    target.each do |t|
      content = t.inner_html.gsub('<br>',",").strip
      Diet.create(
        :univ_id => 106,
        :name => "함지마루",
        :location => "복지관 학생식당",
        :date => @default_dates[i],
        :time => 'breakfast',
        :diet => JSON.generate({:name => content, :price => '2,500'}),
        :extra => '조식과 중식이 같음'
        )
      i += 1
    end

		#석식
		target = @kw_data.css('div.menu_table tr')[3].css('td')
    i = 0
    content = ""
    target.each do |t|
      content = t.inner_html.gsub('<br>',",").strip
      Diet.create(
        :univ_id => 106,
        :name => "함지마루",
        :location => "복지관 학생식당",
        :date => @default_dates[i],
        :time => 'dinner',
        :diet => JSON.generate({:name => content, :price => '2,500'}),
        :extra => nil
        )
      i += 1
    end

		#푸드코트
		target = @kw_data.css('div.menu_table tr')[4].css('td')
    i = 0
    content = ""
    target.each do |t|
      content = t.inner_html.gsub('<br>',",").strip
      Diet.create(
        :univ_id => 106,
        :name => "푸드코트",
        :location => "복지관 학생식당",
        :date => @default_dates[i],
        :time => 'lunch',
        :diet => JSON.generate({:name => content, :price => ''}),
        :extra => nil
        )
      i += 1
    end

	end
end
