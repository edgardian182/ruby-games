=begin
  1. Se reparten las cartas (4)
  2. Cada jugador mira dos de sus cuatro cartas
  3. Uno de los jugadores toma una carta de la baraja o ultima carta devuelta
     Jugador decide si cambia una de sus cartas por la tomada
       Si la cambia, decide posicion y tira la cambiada
       Si no la cambia, tira la carta tomada
  4. El jugador puede parar el juego despues de 4 rondas
       Si decide pararlo los demás jugadores tienen derecho a robar por ultima vez (1 ciclo más)
  5. Turno del otro jugador, vuelve a punto 3
=end

# Cómo representamos una carta?
# Cómo representamos una baraja?
# Cómo representamos una mano?

=begin
  JUEGO
  - La idea es quedar con la menor suma posible en la Mano
  - La Q y el JOKER valen 0
  - J y K valen 10 y los demás su numero normal
=end


# Creamos la clase Card para crear objetos de tipo Carta
require_relative 'clsCard.rb'

# Creamos la clase Deck para crear la Baraja
class Deck
  def initialize
    @cards = []
    build_deck
  end

  def build_deck

    # Simbolos a usar para crear las cartas
    spade = ""
    heart = ""
    club = ""
    diamond = ""
    joker = ""
    File.foreach(Dir.pwd + "/s_spade.txt") do |line|
      spade = line
    end

    File.foreach(Dir.pwd + "/s_heart.txt") do |line|
      heart = line
    end

    File.foreach(Dir.pwd + "/s_club.txt") do |line|
      club = line
    end

    File.foreach(Dir.pwd + "/s_diamond.txt") do |line|
      diamond = line
    end

    File.foreach(Dir.pwd + "/s_joker.txt") do |line|
      joker = line
    end

    [heart, club, spade, diamond].each do |suit|
      (2..10).each do |number|
        @cards << Card.new(suit, number)
      end
      ["J", "Q", "K", "A"].each do |face|
        @cards << Card.new(suit, face)
      end
    end
    ["R", "B"].each do |color|
      @cards << Card.new(color, joker)
    end
    # Revolvemos las cartas
    @cards.shuffle!
  end

  def take!
    @cards.shift
  end
end

class Hand
  attr_reader :cards, :name

  def initialize(deck, player)
    @cards = []
    @deck = deck
    @name = player
  end

  def hit!
    @cards << @deck.take!
  end

  def to_s
    str = ""
    @cards.each do |card|
      str += "#{card.value}-#{card.suit}    "
    end
    str.strip
  end
end

# Inicializamos objetos a utilizar durante el juego
deck = Deck.new
player1 = Hand.new(deck, "Jugador1")
player2 = Hand.new(deck, "Jugador2")

# 1. Repartimos las cartas (4)
c = 0
while c < 4
  player1.hit!
  player2.hit!
  c += 1
end

puts "JUEGO INICIADO"
puts "- Se debe quedar con el menor número de puntos posibles en el total de 4 cartas repartidas teniendo en cuenta que: "
puts "   * La Q y JOKER valen 0"
puts "   * J y K valen 10"
puts "   * Demás cartas valen su numero normal"
puts " - Se destapan dos cartas al inciniar y se van cambiando todas de acuerdo a lo que salga de la baraja"
puts

# Decidir que cartas se van a destapar
puts "Cartas repartidas"
print "Qué dos cartas desea destapar? (A)1-2 (B)3-4 (C)1-3 (D)2-4: "
abrir = ""
puts
while abrir != "correcto"
  abrir = gets.chomp
  case abrir
  when "A"
    puts "Cartas jugador_1 en posicion 1 y 2: #{player1.cards[0]}    #{player1.cards[1]}"
    puts "Cartas jugador_2 en posicion 1 y 2: #{player2.cards[0]}    #{player2.cards[1]}"
    abrir = "correcto"
  when "B"
    puts "Cartas jugador_1 en posicion 3 y 4: #{player1.cards[2]}    #{player1.cards[3]}"
    puts "Cartas jugador_2 en posicion 3 y 4: #{player2.cards[2]}    #{player2.cards[3]}"
    abrir = "correcto"
  when "C"
    puts "Cartas jugador_1 en posicion 1 y 3: #{player1.cards[0]}    #{player1.cards[2]}"
    puts "Cartas jugador_2 en posicion 1 y 3: #{player2.cards[0]}    #{player2.cards[2]}"
    abrir = "correcto"
  when "D"
    puts "Cartas jugador_1 en posicion 2 y 4: #{player1.cards[1]}    #{player1.cards[3]}"
    puts "Cartas jugador_2 en posicion 2 y 4: #{player2.cards[1]}    #{player2.cards[3]}"
    abrir = "correcto"
  else
    puts "Opción no valida"
  end
end

# Variable para guardar las cartas que quedan en el Pozo
ultima_carta = []
puts

# Variable que se utiliza para terminar el juego
terminar_juego = 0
# Variable para contar la cantidad de turnos jugados
ciclo = 0

players = [player2, player1]

# Ciclo del juego
while terminar_juego < 2
  ciclo += 1
  # Variable para determinar la mano de que jugador está jugando el turno
  turno = players.shift
  players << turno

  puts
  puts "Turno #{players[0].name}"

  opcion = ""
  while opcion != "correcto"
    # Mostramos la posibilidad de tomar la ultima carta del Pozo si existe una carta en él
    puts ultima_carta.empty? ? "Tomar carta de Baraja(R)" : "Tomar carta de Baraja(R) o tomar #{ultima_carta[-1]}(T)?"
    opcion = gets.chomp
    if opcion == "R"
      ultima_carta << deck.take!
      puts "Carta: #{ultima_carta[-1]}"
      opcion = "correcto"
    elsif opcion == "T"
      puts "Carta: #{ultima_carta[-1]}"
      opcion = "correcto"
    else
      puts "Opción no valida, toma una carta"
    end
  end

  puts
  puts "Deseas cambiar una de tus cartas por la que has tomado? Si(s) / No(n) "
  decision = gets.chomp
  if (decision == "s") || (decision == "si") || (decision == "Si") || (decision == "SI")
    puts "Por la carta ubicada en qué lugar? 1? 2? 3? 4?"
    lugar = 10

    while lugar
      lugar = gets.chomp.to_i
      case lugar
      when 1
        sale = players[0].cards[0]
        players[0].cards[0] = ultima_carta[-1]
        ultima_carta << sale
        puts "Carta botada: #{ultima_carta[-1]}"
        break
      when 2
        sale = players[0].cards[1]
        players[0].cards[1] = ultima_carta[-1]
        ultima_carta << sale
        puts "Carta botada: #{ultima_carta[-1]}"
        break
      when 3
        sale = players[0].cards[2]
        players[0].cards[2] = ultima_carta[-1]
        ultima_carta << sale
        puts "Carta botada: #{ultima_carta[-1]}"
        break
      when 4
        sale = players[0].cards[3]
        players[0].cards[3] = ultima_carta[-1]
        ultima_carta << sale
        puts "Carta botada: #{ultima_carta[-1]}"
        break
      else
        puts "Solo decide que numero"
      end
    end

  end

  if ciclo >= 9 && terminar_juego < 1
    puts "Desea cerrar el juego? Si(s)  No(n): "
    cerrar = gets.chomp
  elsif terminar_juego < 1
    puts "Muy bien, turno siguiente jugador"
  else
    puts
    puts "JUEGO TERMINADO"
  end

  # Deja que el siguiente jugador juegue y luego acaba el juego
  if cerrar == "s"
    terminar_juego += 1
  end
end

# PROBLEMA ACA
r_p1 = 0
player1.cards.each do |card|
  r_p1 += card.value.to_i
end

r_p2 = 0
player2.cards.each do |card|
  r_p2 += card.value.to_i
end

puts
puts "Total Jugador_1: #{player1}    [#{r_p1}]"
puts "Total Jugador_2: #{player2}    [#{r_p2}]"
puts

if r_p1 < r_p2
  File.foreach(Dir.pwd + "/s_winner_p1.txt") do |line|
    puts line
  end
elsif r_p1 > r_p2
  File.foreach(Dir.pwd + "/s_winner_p2.txt") do |line|
    puts line
  end
else
  puts "EMPATADOS"
end