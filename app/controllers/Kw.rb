#광운대학교 일반
class Kw
  #Initialize
  #2016-11-07 update (처리내용 : 광운대 홈페이지 개편으로 인한 전체 소스 엎기)
  def initialize
		@url = "http://www.kw.ac.kr/ko/life/facility11.do"
		@parsed_data = Nokogiri::HTML(open(@url))
		@default_dates = Array.new

		#Init Mon to Fri
		(0..4).each do |i|
      @default_dates << ((Date.parse @parsed_data.css('h4').text.split(' ')[2]) + i).to_s
    end
  end
	#Initialize end
	
	#Main method scraping
	#2016-11-07 update (처리내용 : 광운대 홈페이지 개편으로 인한 전체 소스 엎기)
	def scrape
    currentDate = 0
    eachmenu = ''

		@json_parse_data = JSON.parse(@parsed_data.css('textarea').text)
		#옛향 중식
		@old_smell_lunch = @json_parse_data["diet_0"][0]
    #옛향 석식
    @old_smell_dinner = @json_parse_data["diet_1"][0]
    #푸드코트
    @food_cort = @json_parse_data["diet_2"][0]

    #푸드코트 중석식
    foodcorts = Array.new
    foodcorts << @food_cort["d1"].gsub("\n",",")
    foodcorts << @food_cort["d2"].gsub("\n",",")
    foodcorts << @food_cort["d3"].gsub("\n",",")
    foodcorts << @food_cort["d4"].gsub("\n",",")
    foodcorts << @food_cort["d5"].gsub("\n",",")

    #옛향 중식
    contents = Array.new
    contents << @old_smell_lunch["d1"].gsub("\n",",")
    contents << @old_smell_lunch["d2"].gsub("\n",",")
    contents << @old_smell_lunch["d3"].gsub("\n",",")
    contents << @old_smell_lunch["d4"].gsub("\n",",")
    contents << @old_smell_lunch["d5"].gsub("\n",",")

		(0..4).each do |i|
      eachmenu = JSON.generate({:name => contents[i], :price => '2,500'})
      if foodcorts[i] != ""
        eachmenu += (',' + JSON.generate({:name => foodcorts[i], :price => '3,000~3,500'}))
      end

      if contents[i] != "" && foodcorts != ""
        Diet.create(
          :univ_id => 8,
          :name => "함지마루",
          :location => "복지관 학생식당",
          :date => @default_dates[currentDate],
          :time => 'lunch',
          :diet => ArrJson(eachmenu),
          :extra => nil
          )

        currentDate = currentDate + 1
      end
    end

		contents.clear
    currentDate = 0

    #석식
    contents << @old_smell_dinner["d1"].gsub("\n",",")
    contents << @old_smell_dinner["d2"].gsub("\n",",")
    contents << @old_smell_dinner["d3"].gsub("\n",",")
    contents << @old_smell_dinner["d4"].gsub("\n",",")
    contents << @old_smell_dinner["d5"].gsub("\n",",")

    (0..4).each do |i|
      eachmenu = JSON.generate({:name => contents[i], :price => '2,500'})
      if foodcorts[i] != ""
        eachmenu += (',' + JSON.generate({:name => foodcorts[i], :price => '3,000~3,500'}))
      end

      if contents[i] != "" && foodcorts != ""
        Diet.create(
          :univ_id => 8,
          :name => "함지마루",
          :location => "복지관 학생식당",
          :date => @default_dates[currentDate],
          :time => 'dinner',
          :diet => ArrJson(eachmenu),
          :extra => nil
          )

        currentDate = currentDate + 1
      end
    end

    contents.clear
    currentDate = 0

	end
	#scrape end
	
	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end
  #ArrJson end
 
end #Class end
