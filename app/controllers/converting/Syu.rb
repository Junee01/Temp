#삼육대학교
class Syu
	#Initialize
	def initialize
		#URL, Parse <HTML>
		@url = "http://www.syu.ac.kr/web/kor/life_d_03_02_b"
		@parsed_data = Nokogiri::HTML(open(@url))
		@default_dates = Array.new

		#Init Mon to Fri
		today = Date.today
    while (today.monday? == false)
    	today = today - 1
    end
    d = 0
    (0..4).each do |d|
    	@default_dates << ((Date.parse today.to_s) + d).to_s
    end
	end #Initialize end

	#Main method scraping
	def scrape
		eachmenus = ''
		content = ''
		price = ''
		currentDate = 0
	    
    #프랜들리
    target = @parsed_data.css('table.table-a tbody td')
    check = 0

    @default_dates.each do |dat|
    	eachmenus = ""
      target.each do |t|
        if check == 0
          content = t.text
          check = 1
        else
          price = t.text
          if eachmenus == ""
            #첫 번째 메뉴면, 콤마없이
            eachmenus += JSON.generate({:name => content, :price => price})
          else
            #하나 이상 메뉴면 콤마 추가
            eachmenus += (',' + JSON.generate({:name => content, :price => price}))
          end
          check = 0
        end
      end
		  #조/중/석이 같은 메뉴입니다. 
		  Diet.create(
        :univ_id => 5,
        :name => "프랜들리",
        :location => "바율관1층",
        :date => dat,
        :time => 'breakfast',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
       Diet.create(
        :univ_id => 5,
        :name => "프랜들리",
        :location => "바율관1층",
        :date => dat,
        :time => 'lunch',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
       Diet.create(
        :univ_id => 5,
        :name => "프랜들리",
        :location => "바율관1층",
        :date => dat,
        :time => 'dinner',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
    end

		#파인하우스
		pinehouse = Array.new
    pinehouse << JSON.generate({:name => "비빔밥", :price => "2,700"})
    pinehouse << JSON.generate({:name => "비빔밥(잡곡)", :price => "3,200"})
    pinehouse << JSON.generate({:name => "돌솥비빔밥", :price => "2,700"})
    pinehouse << JSON.generate({:name => "돌솥비빔밥(잡곡)", :price => "3,500"})
    pinehouse << JSON.generate({:name => "치즈돌솥비빔밥", :price => "3,200"})
    pinehouse << JSON.generate({:name => "청국장", :price => "3,000"})
    pinehouse << JSON.generate({:name => "육개장", :price => "2,700"})
    pinehouse << JSON.generate({:name => "찌개(된장/순두부/콩비지/김치)", :price => "2,700"})
    pinehouse << JSON.generate({:name => "부대찌개", :price => "3,000"})
    pinehouse << JSON.generate({:name => "김치덮밥", :price => "2,700"})
    pinehouse << JSON.generate({:name => "덮밥(잡채/마파두부/버섯)", :price => "3,200"})
    pinehouse << JSON.generate({:name => "들깨순두부", :price => "3,000"})
    pinehouse << JSON.generate({:name => "공기밥", :price => "500"})
    pinehouse << JSON.generate({:name => "현미밥", :price => "1,000"})
    pinehouse << JSON.generate({:name => "버섯두부전골", :price => "10,000"})
    pinehouse << JSON.generate({:name => "만두전공", :price => "10,000"})
    pinehouse << JSON.generate({:name => "김치주먹밥", :price => "1,300"})
    pinehouse << JSON.generate({:name => "샌드위치(사과/야채)", :price => "1,500"})
    pinehouse << JSON.generate({:name => "베지버거", :price => "2,000"})
    pinehouse << JSON.generate({:name => "야채김밥", :price => "1,700"})
    pinehouse << JSON.generate({:name => "치즈김밥/구프랑김밥", :price => "2,000"})
    pinehouse << JSON.generate({:name => "떡만두국", :price => "3,000"})
    pinehouse << JSON.generate({:name => "라면", :price => "1,700"})
    pinehouse << JSON.generate({:name => "치즈라면/만두라면", :price => "2,000"})
    pinehouse << JSON.generate({:name => "김치떡라면", :price => "2,000"})
    pinehouse << JSON.generate({:name => "채식라면", :price => "2,300"})
    pinehouse << JSON.generate({:name => "잔치국수/칼국수", :price => "2,500"})
    pinehouse << JSON.generate({:name => "토마토스파게티", :price => "3,000"})
    pinehouse << JSON.generate({:name => "수제비", :price => "2,300"})
    pinehouse << JSON.generate({:name => "들깨수제비", :price => "2,800"})
    pinehouse << JSON.generate({:name => "칼국수(들깨/만두/버섯)", :price => "3,000"})
    pinehouse << JSON.generate({:name => "떡볶이", :price => "2,500"})
    pinehouse << JSON.generate({:name => "부대떡볶이", :price => "5,000"})
    pinehouse << JSON.generate({:name => "치즈떡볶이", :price => "6,000"})
    pinehouse << JSON.generate({:name => "유부초밥", :price => "2,500"})
    pinehouse << JSON.generate({:name => "우동", :price => "1,800"})
    pinehouse << JSON.generate({:name => "우동(곱)", :price => "2,300"})
    pinehouse << JSON.generate({:name => "짜장면", :price => "2,300"})
    pinehouse << JSON.generate({:name => "짜장면(곱)", :price => "2,800"})
    pinehouse << JSON.generate({:name => "짬뽕", :price => "2,500"})
    pinehouse << JSON.generate({:name => "쩜뽕(곱)", :price => "3,000"})
    pinehouse << JSON.generate({:name => "간짜장", :price => "3,000"})
    pinehouse << JSON.generate({:name => "간짜장(곱)", :price => "3,500"})
    pinehouse << JSON.generate({:name => "볶음밥", :price => "2,700"})
    pinehouse << JSON.generate({:name => "쟁반짜장", :price => "6,000"})
    pinehouse << JSON.generate({:name => "쟁반짬뽕", :price => "7,000"})
    pinehouse << JSON.generate({:name => "쟁반쫄면", :price => "6,500"})
    pinehouse << JSON.generate({:name => "버섯탕수육(2인기준)", :price => "8,000"})
    pinehouse << JSON.generate({:name => "냉면", :price => "2,500"})
    pinehouse << JSON.generate({:name => "냉면(곱)", :price => "3,000"})
    pinehouse << JSON.generate({:name => "냉모밀(2인기준)", :price => "5,000"})

    eachmenus = ""
    pinehouse.each do |p|
    	if eachmenus == ""
        #첫 번째 메뉴면, 콤마없이
        eachmenus += p
      else
        #하나 이상 메뉴면 콤마 추가
        eachmenus += (',' + p)
      end
    end

    #조/중/석이 같은 메뉴입니다.
    @default_dates.each do |dat|
      Diet.create(
        :univ_id => 5,
        :name => "파인하우스",
        :location => "학생회관1층",
        :date => dat,
        :time => 'breakfast',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
      Diet.create(
        :univ_id => 5,
        :name => "파인하우스",
        :location => "학생회관1층",
        :date => dat,
        :time => 'lunch',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
      Diet.create(
        :univ_id => 5,
        :name => "파인하우스",
        :location => "학생회관1층",
        :date => dat,
        :time => 'dinner',
        :diet => ArrJson(eachmenus),
        :extra => nil
        )
    end

	end #scrape end

	#Make a Array of Json
	def ArrJson(str)
    tmp = ""
    tmp += ("[" + str + "]")
    tmp
  end #ArrJson end

end #Class end
