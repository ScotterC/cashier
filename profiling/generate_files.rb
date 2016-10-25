lower = [('a'..'z')].map { |i| i.to_a }.flatten
upper = [('A'..'Z')].map { |i| i.to_a }.flatten
mixed = lower + upper

mixedstring, lowerstring, upperstring = "", "", ""

for i in 0..999
  mixedstring += (10..15+rand(100)).map { mixed[rand(mixed.length)] }.join + "\n"
  lowerstring += (10..15+rand(100)).map { lower[rand(lower.length)] }.join + "\n"
  upperstring += (10..15+rand(100)).map { upper[rand(upper.length)] }.join + "\n"
end

File.write('mixedcase.txt', mixedstring)
File.write('lowercase.txt', lowerstring)
File.write('uppercase.txt', upperstring)