class JogosJogadoresController < ApplicationController
  before_action :authenticate_usuario!, :except => [:buscar_jogadores_jogo, :artilharia]
  before_action :set_jogos_jogador, only: [:show, :edit, :update, :destroy]

  # GET /jogos_jogadores
  # GET /jogos_jogadores.json
  def index
    @jogos_jogadores = JogosJogador.all
  end

  # GET /jogos_jogadores/1
  # GET /jogos_jogadores/1.json
  def show
  end

  # GET /jogos_jogadores/new
  def new
    @jogos_jogador = JogosJogador.new
    @lista_jogadores_jogo = JogosJogador.where('jogo_id = ?', Jogo.find_by_dia(params[:dia].to_date).id)
  end

  # GET /jogos_jogadores/1/edit
  def edit
    @jogo = JogosJogador.find(params[:id]).jogo.id
    @lista_jogadores_jogo = JogosJogador.where('jogo_id = ?', @jogo)
  end

  # POST /jogos_jogadores
  # POST /jogos_jogadores.json
  def create
    @jogos_jogador = JogosJogador.new(jogos_jogador_params)
    @jogos_jogador.jogo_id = Jogo.find_by_dia(jogos_jogador_params[:jogo_id].to_date).id

    respond_to do |format|
      if @jogos_jogador.save
        @lista_jogadores_jogo = JogosJogador.where('jogo_id = ?', Jogo.find_by_dia(jogos_jogador_params[:jogo_id].to_date).id)
        format.js
        # format.html { redirect_to @jogos_jogador, notice: 'Jogos jogador was successfully created.' }
        # format.json { render :show, status: :created, location: @jogos_jogador }
      else
        format.html { render :new }
        format.json { render json: @jogos_jogador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jogos_jogadores/1
  # PATCH/PUT /jogos_jogadores/1.json
  def update
    if @jogos_jogador.update(jogos_jogador_params)
      redirect_to controller: :jogos, action: :index
    else
      redirect_to controller: :jogos, action: :index
    end
  end

  # DELETE /jogos_jogadores/1
  # DELETE /jogos_jogadores/1.json
  def destroy
    @jogo = JogosJogador.find(params[:id]).jogo.dia
    # raise @jogo.inspect
    @jogos_jogador.destroy
    redirect_to controller: :jogos_jogadores, action: :new, dia: @jogo
    # redirect_to new_jogos_jogador_path, dia: @jogo
    # redirect_to controller: :jogos, action: :index
  end

  def buscar_jogadores_jogo
    @jogo = Jogo.find(params[:jogo_id])
    @jogadores = JogosJogador.joins(:jogador).merge(Jogador.order(nome: :asc)).where('jogo_id = ?', params[:jogo_id])
    # @jogadores = JogosJogador.where('jogo_id = ?', params[:jogo_id])

    respond_to do |format|
      format.html {render :jogadores_jogo}
    end
  end

  def artilharia
    @artilheiros = JogosJogador.artilharia
  end

  def sortear_time
    @jogadores = Jogador.order(:nome).where(ativo: true)
    if params[:commit] == "Sortear" && !params[:lista_jogadores].nil?
      jogadores = params[:lista_jogadores]
      quantidade_jogadores_time = params[:quantidade_jogadores_time].to_i
      quantidade_times = (jogadores.length / quantidade_jogadores_time)
      time = 0
      @lista_jogadores = []
      quantidade_times.times do |index_time|
        time = index_time + 1
        array_jogadores_com_time = []
        quantidade_jogadores_time.times do |index_jogador|
          jogador = jogadores[rand(jogadores.length)]
          array_jogadores_com_time.push({time: time, jogador: jogador})
          jogadores.delete(jogador)
        end
        @lista_jogadores.push(array_jogadores_com_time)
      end
      if !jogadores.blank?
        array_jogadores_sem_time = []
        jogadores.each do |jogador_sem_time|
          array_jogadores_sem_time.push({time: (time+1), jogador: jogador_sem_time})
        end
        @lista_jogadores << array_jogadores_sem_time
      end
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jogos_jogador
      @jogos_jogador = JogosJogador.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jogos_jogador_params
      params.require(:jogos_jogador).permit(:jogo_id, :jogador_id, :gol, :cota)
    end
end
