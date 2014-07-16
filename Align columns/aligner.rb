class Aligner

  def initialize
    @input = File.open("input.txt")
    @words = []
    @input.each do |i|
      i.gsub!("\n", "")
      @words << i.split("$")
    end
  end


  def align(words)
    max = words.flatten.max_by { |w| w.size }.size
    words.flatten.each do |w|
      space = " " * ((max - w.size) + 1)
      print w + space
    end
  end

end