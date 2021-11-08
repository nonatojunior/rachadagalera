class Jogador < ActiveRecord::Base
	require "prawn"
	require "prawn/table"

	def self.gerar_lista
		diretorio = File.join(Rails.root, 'app', 'arquivos')
		arquivo = 'lista_jogadores.pdf'
		pdf_options = {
				:page_size => "A4",
				:page_layout => :portrait,
				:position => :center
			}
		FileUtils.mkdir_p(diretorio) unless Dir.exists?(diretorio)
		ficha = Prawn::Document.generate(diretorio + '/' + arquivo, pdf_options) do
			text "Lista de Jogadores", :align => :center
			move_down 5
			text "Jogo do Dia  ___/___/#{Time.now.year}", :align => :center
			move_down 10
			data = [ ["Qtdd", "Jogador", "R$ Cota", "Gols"] ]
			table(data, :cell_style => { :overflow => :shrink_to_fit, :size => 12, :width => 15, :height => 20, :background_color => "BEBEBE" }, :position => :center, :column_widths => [40, 350, 65, 65])
			contador = 0
			Jogador.where(ativo: true).order('nome ASC').each do |jogador|
				data = [ ["#{contador += 1}º", "#{jogador.nome}", "", ""] ]
				table(data, :cell_style => { :overflow => :shrink_to_fit, :size => 10, :width => 15, :height => 20 }, :position => :center, :column_widths => [40, 350, 65, 65])
			end
			data.pop()
			5.times do
				data << ["#{contador += 1}º", "", "", ""]
			end
			table(data, :cell_style => { :overflow => :shrink_to_fit, :size => 10, :width => 15, :height => 20 }, :position => :center, :column_widths => [40, 350, 65, 65])
			move_down 10
			text "Total arrecadado R$ ____________"
			text "Total despesas R$ ____________"
			text "Saldo R$ ____________"
			move_down 10
			text "OBSERVAÇÃO"
			text "______________________________________________________________________________
						______________________________________________________________________________"

		end
		
		return diretorio + '/' + arquivo
	end

end
