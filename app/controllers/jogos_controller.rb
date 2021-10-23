class JogosController < ApplicationController
  before_action :authenticate_usuario!, :except => [:index_usuario]
  before_action :set_jogo, only: [:show, :edit, :update, :destroy]

  # GET /jogos
  # GET /jogos.json
  def index
    @jogos = Jogo.all.order('dia DESC')
  end

  def index_usuario
    @jogos = Jogo.all.order('dia DESC')
  end

  # GET /jogos/1
  # GET /jogos/1.json
  def show
  end

  # GET /jogos/new
  def new
    @jogo = Jogo.new
  end

  # GET /jogos/1/edit
  def edit
  end

  # POST /jogos
  # POST /jogos.json
  def create
    @jogo = Jogo.new(jogo_params)

    respond_to do |format|
      if @jogo.save
        # format.html { redirect_to @jogo, notice: 'Jogo was successfully created.' }
        format.html { redirect_to new_jogos_jogador_path(dia: @jogo.dia), notice: 'Jogo was successfully created.' }
        format.json { render :show, status: :created, location: @jogo }
      else
        format.html { render :new }
        format.json { render json: @jogo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jogos/1
  # PATCH/PUT /jogos/1.json
  def update
    respond_to do |format|
      if @jogo.update(jogo_params)
        format.html { redirect_to @jogo, notice: 'Jogo was successfully updated.' }
        format.json { render :show, status: :ok, location: @jogo }
      else
        format.html { render :edit }
        format.json { render json: @jogo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jogos/1
  # DELETE /jogos/1.json
  def destroy
    @jogo.destroy
    respond_to do |format|
      format.html { redirect_to jogos_url, notice: 'Jogo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def abiri_modal_adicionar_sumula
    @jogo_id = params[:jogo_id]

    respond_to do |format|
      format.js
    end
  end

  def adicionar_sumula
    Jogo.find(params[:frm][:jogo_id]).update_attribute(:sumula, params[:frm][:sumula])

    redirect_to action: :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jogo
      @jogo = Jogo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jogo_params
      params.require(:jogo).permit(:dia, :tipo_jogo, :sumula, :despesa, :descricao_despesa)
    end
end
