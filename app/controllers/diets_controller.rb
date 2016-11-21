require 'Duksung' #덕성여자대학교(2)
require 'Hansung' #한성대학교(3)
require 'Mju' #명지대학교 인문캠퍼스(4)
require 'Syu' #삼육대학교(5)
require 'DongaSh' #동아대학교 승학캠퍼스(6)
require 'DongaBm' #동아대학교 구덕/부민캠퍼스(7)
require 'Kw'  #광운대학교(구)(8)
require 'KwFoodCort'  #광운대학교 푸드코트(8)
require 'Inha'  #인하대학교(9)
#require 'HanyangErica'  #한양대학교 에리카(10)
require 'Dongduk' #동덕여자대학교(560)
require 'MjuSc' #명지대학교 자연캠퍼스(800)
require 'KhuSuwon'  #경희대학교 수원캠퍼스(801)
require 'KhuSeoul'	#경희대학교 서울캠퍼스(802)

class DietsController < ApplicationController
  before_action :set_diet, only: [:show, :edit, :update, :destroy]

  # GET /diets
  # GET /diets.json
  def index
    @diets = Diet.all

		puts "Scraping begins..."

		#TCP 요청을 보냈을 때, 페이지 자체 문제로 Failed이 나면, 복구하고 우선 다음 작업을 수행합니다. rescue의 역할입니다.

		#동덕여대
		begin
     	dongduk = Dongduk.new
      dongduk.scrape
			puts "Dongduk University Success."
    rescue
      puts "Dongduk University was rescued."
    end
			  
		#덕성여대
		begin
			duksung = Duksung.new
      duksung.scrape
			puts "Duksung University Success."
    rescue
    	puts "Duksung University was rescued."
    end

		#한성대
		begin
			hansung = Hansung.new
      hansung.scrape
			puts "Hansung University Success."
    rescue
      puts "Hansung University was rescued."
    end

		#한양대 에리카
		#begin
		#	hanyang_erica = HanyangErica.new
    #  hanyang_erica.scrape
		#	puts "Hanyang Erica University Success."
    #rescue
    #  puts "Hanyang Erica University was rescued."
    #end

		#인하대
		begin
			inha = Inha.new
      inha.scrape
			puts "Inha University Success."
    rescue
      puts "Inha University was rescued."
    end

		#명지대 인문
		begin
			mju = Mju.new
      mju.scrape
			puts "Mju University Success."
    rescue
      puts "Mju University was rescued."
    end

		#삼육대
		begin
			syu = Syu.new
      syu.scrape
			puts "Syu University Success."
    rescue
      puts "Syu University was rescued."
    end

		#동아대 승학캠퍼스
		begin
      dongash = DongaSh.new
      dongash.scrape
    rescue
      puts 'rescued.'
    end

		#동아대 구덕/부민캠퍼스
		begin
      dongabm = DongaBm.new
      dongabm.scrape
    rescue
      puts 'rescued.'
    end

		#광운대
		begin
			kw = Kw.new
      kw.scrape
			puts "Kw University Success."
    rescue
      puts "Kw University was rescued."
    end
	
		#광운대 푸드코트
		begin
			kwfc = KwFoodCort.new
			kwfc.scrape
			puts "Kw FoodCort Success."
		rescue
			puts "Kw FoodCort was rescued."
		end

		#명지대학교 자연캠퍼스(800)
		begin
      mjuSc = MjuSc.new
      mjuSc.scrape
      puts "Mju sc Success."
    rescue
    	puts "Mju sc was rescued."
		end

		puts "All Scraping completed."
	
		#경희대학교 수원캠퍼스(801)
		begin
      khuSuwon = KhuSuwon.new
      khuSuwon.scrape
      puts "khu Suwon Success."
		rescue
      puts "khu Suwon was rescued."
    end

		#경희대학교 서울캠퍼스(802)
		begin
			khuSeoul = KhuSeoul.new
			khuSeoul.scrape
			puts "khu Seoul Success."
		rescue
			puts "khu Seoul was rescued."
		end
	
		#Diet.delete_all
  end

  # GET /diets/1
  # GET /diets/1.json
  def show
  end

  # GET /diets/new
  def new
    @diet = Diet.new
  end

  # GET /diets/1/edit
  def edit
  end

  # POST /diets
  # POST /diets.json
  def create
    @diet = Diet.new(diet_params)

    respond_to do |format|
      if @diet.save
        format.html { redirect_to @diet, notice: 'Diet was successfully created.' }
        format.json { render :show, status: :created, location: @diet }
      else
        format.html { render :new }
        format.json { render json: @diet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diets/1
  # PATCH/PUT /diets/1.json
  def update
    respond_to do |format|
      if @diet.update(diet_params)
        format.html { redirect_to @diet, notice: 'Diet was successfully updated.' }
        format.json { render :show, status: :ok, location: @diet }
      else
        format.html { render :edit }
        format.json { render json: @diet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diets/1
  # DELETE /diets/1.json
  def destroy
    @diet.destroy
    respond_to do |format|
      format.html { redirect_to diets_url, notice: 'Diet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diet
      @diet = Diet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diet_params
      params.require(:diet).permit(:univ_id, :name, :location, :date, :time, :diet, :extra)
    end
end
