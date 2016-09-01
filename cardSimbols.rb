spade = ""
heart = ""
club = ""
diamond = ""
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

File.open(Dir.pwd + "/Q.txt", 'w') do |f|
  f << "********\n"
  f << "|Q    #{heart}|\n"
  f << "|      |\n"
  f << "|#{heart}    Q|\n"
  f << "********"
end