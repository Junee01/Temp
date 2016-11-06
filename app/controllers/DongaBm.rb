#동아대학교 부민캠퍼스
class DongaBm
  #Initialize
  def initialize
    #URL, Dates
    @default_dates = Array.new
    @urls = Array.new

    today = Date.today
    while (today.monday? == false)
      today = today - 1
    end

    #Init Mon to Fri and urls
    (0..4).each do |i|
      @default_dates << ((Date.parse today.to_s) + i).to_s
      @urls << "http://www.donga.ac.kr/MM_PAGE/SUB007/SUB_007005005.asp?PageCD=007005005&seldate=" + @default_dates[i] + "#st"
    end
  end #Initialize end

	#Main method scraping
	def scrape
    eachmenus = ''
    time = ''
    price = ''

    #Mon ~ Fri
    (0..4).each do |day|
      parsed_data = Nokogiri::HTML(open(@urls[day]))
      target = parsed_data.css('table.sk01TBL')[1]

      #식당 이름 저장
      names = Array.new
      (10..14).each do |i|
        names << target.css('td.sk01TD')[i].text.strip
      end
      names << target.css('td.sk02TD')[5].text.strip

      #식당 메뉴 저장
      contents = Array.new
      (15..19).each do |i|
        contents << target.css('td.sk01TD')[i].text.strip.gsub("\n\n","\n").gsub("\n\n","\n").gsub("\n",",")
      end
      contents << target.css('td.sk02TD')[6].text.strip.gsub("\n\n","\n").gsub("\n\n","\n").gsub("\n",",")

      (0..5).each do |part|
      if contents[part] == " "  #콘텐츠에 문제가 있으면 Skip
				next
      end

      eachmenus = JSON.generate({:name => contents[part], :price => ""})

      #Breakfast ~ Dinner
      Diet.create(
          :univ_id => 7,
          :name => names[part],
          :location => '',
          :date => @default_dates[day],
          :time => 'breakfast',
          :diet => ArrJson(eachmenus),
          :extra => nil
          )
        Diet.create(
          :univ_id => 7,
          :name => names[part],
          :location => '',
          :date => @default_dates[day],
          :time => 'lunch',
          :diet => ArrJson(eachmenus),
          :extra => nil
          )
        Diet.create(
          :univ_id => 7,
          :name => names[part],
          :location => '',
          :date => @default_dates[day],
          :time => 'dinner',
          :diet => ArrJson(eachmenus),
          :extra => nil
          )
      end
    end
      
  end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
