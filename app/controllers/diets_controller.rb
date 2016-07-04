require 'Dongduk'
require 'Donga'
require 'Duksung'
require 'Hansung'
require 'Hanyang'
require 'Inha'
require 'Mju'
require 'Syu'
require 'Kw'

class DietsController < ApplicationController
  before_action :set_diet, only: [:show, :edit, :update, :destroy]

  # GET /diets
  # GET /diets.json
  def index
    @diets = Diet.all

		puts "Scraping begins..."

		#TCP 요청을 보냈을 때, 페이지 자체 문제로 Failed이 나면, 복구하고 우선 다음 작업을 수행합니다. rescue의 역할입니다.

		#동덕여대
		#begin
    # 	dongduk = Dongduk.new
    #  dongduk.scrape
		#	puts "Dongduk University Success."
    #rescue
    #  puts "Dongduk University was rescued."
    #end
			  
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
		begin
			hanyang_erica = Hanyang.new
      hanyang_erica.scrape
			puts "Hanyang University Success."
    rescue
      puts "Hanyang University was rescued."
    end

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

		#동아대
		begin
			donga = Donga.new
      donga.scrape
			puts "Donga University Success."
    rescue
      puts "Donga University was rescued."
    end

		#광운대
		#begin
		#	kw = Kw.new
    #  kw.scrape
		#	 puts "Kw University Success."
    #rescue
    #  puts "Kw University was rescued."
    #end

		puts "All Scraping completed."
		
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
