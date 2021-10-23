class JogadoresController < ApplicationController
  before_action :authenticate_usuario!, :except => [:index_usuario]
  before_action :set_jogador, only: [:show, :edit, :update, :destroy]

  # GET /jogadores
  # GET /jogadores.json
  def index
    @jogadores = Jogador.all.order('nome ASC')
  end

  def index_usuario
    @jogadores = Jogador.where(ativo: true).order('nome ASC')
  end

  # GET /jogadores/1
  # GET /jogadores/1.json
  def show
  end

  # GET /jogadores/new
  def new
    @jogador = Jogador.new
  end

  # GET /jogadores/1/edit
  def edit
  end

  # POST /jogadores
  # POST /jogadores.json
  def create
    @jogador = Jogador.new(jogador_params)

    respond_to do |format|
      if @jogador.save
        format.html { redirect_to @jogador, notice: 'Jogador was successfully created.' }
        format.json { render :show, status: :created, location: @jogador }
      else
        format.html { render :new }
        format.json { render json: @jogador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jogadores/1
  # PATCH/PUT /jogadores/1.json
  def update
    respond_to do |format|
      if @jogador.update(jogador_params)
        format.html { redirect_to @jogador, notice: 'Jogador was successfully updated.' }
        format.json { render :show, status: :ok, location: @jogador }
      else
        format.html { render :edit }
        format.json { render json: @jogador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jogadores/1
  # DELETE /jogadores/1.json
  def destroy
    @jogador.destroy
    respond_to do |format|
      format.html { redirect_to jogadores_url, notice: 'Jogador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def lista_jogadores
    lista = Jogador.gerar_lista

    send_file lista, disposition: 'inline'
  end

  def atualizar_status
    jogador = Jogador.find(params[:id])
    if jogador.ativo?
      jogador.ativo = false
    else
      jogador.ativo = true
    end
    jogador.save

    redirect_to jogadores_path
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jogador
      @jogador = Jogador.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jogador_params
      params.require(:jogador).permit(:nome, :ativo)
    end
end
