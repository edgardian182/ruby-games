# Necesita archivos con los simbolos en la misma carpeta
class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
    create_file
  end

  def create_file
    File.open(Dir.pwd + "/#{@value}_#{@suit}.txt", 'w') do |f|
      f << "********\n"
      f << "|#{@value}    #{@suit}|\n"
      f << "|#{@value == 10 ? " " : ""}      |\n" # Pone un espacio extra si es 10
      f << "|#{@suit}    #{@value}|\n"
      f << "********"
    end
  end

  # Para juego de qCero
  def value
    return 10 if ["J", "K"].include?(@value)
    return 1 if "A" == @value
    return 0 if ["Q", "JOKER"].include?(@value)
    return @value
  end

  def to_s
    File.foreach(Dir.pwd + "/#{@value}_#{@suit}.txt") do |line|
      puts line
    end
    ""
  end

end
