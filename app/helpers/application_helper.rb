module ApplicationHelper
  def dia_semana(dia)
    if dia == "Sun"
      return "Domingo"
    elsif dia == "Mon"
      return "Segunda"
    elsif dia == "Tue"
      return "Terça"  
    elsif dia == "Wed"
      return "Quarta"
    elsif dia == "Thu"
      return "Quinta"
    elsif dia == "Fri"
      return "Sexta"
    elsif dia == "Sat"
      return "Sábado"
    end
  end
end
