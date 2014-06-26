class Deck
  def initialize(phrase)
    @ab = ("A".."Z").to_a.join("")
    @cards = (1..52).to_a + ["A", "B"]
    @phrase = phrase
  end

  def encrypt_deck
    # Step 1
    @phrase = group_in_five(@phrase)
    # Step 2
    convert_to_numbers(@phrase)
    generate_keystream
  end

  def group_in_five(p)
    group = ""
    p = p.upcase.tr("^A-Z", "")
    ((p.size+1) / 5).times { |i| group << p[i*5, 5] << " " }
    group[-1] = ""
    last_part = group.split(" ")[-1]
    if last_part.size < 5
      (5 - (last_part.size % 5)).times { group << "X" }
    end
    return group
  end

  def convert_to_numbers(msg)
    @indexed_phrase = ""
    msg.each_char do |m|
      if m == " "
        @indexed_phrase << " "
        next
      end
      @indexed_phrase << "#{@ab.index(m) + 1} "
    end
  end

  def generate_keystream
    @ks = ""
    n = (@phrase.tr(" ", "")).length
    n.times do |x|
      move_a
      move_b
      triple_cut
      count_cut
      @ks << get_number.to_s << " "
      # puts @ks
    end
  end

  def move_a
    move_jokers(@cards.index("A"))
  end

  def move_b
    move_jokers(move_jokers(@cards.index("B")))
  end

  # Move Joker A 1 index down (right | Index 53)
  # Move Joker B 2 indexes down
  def move_jokers(i) # <================ REFACTOR THIS PLZ
    puts "Joker: #{i}\n"
    puts "A: #{@cards.join(" ")}"
    if i < 53
      puts "#{i} < 53\n"
      @cards[i], @cards[i+1] = @cards[i+1], @cards[i]
    else
      puts "> 53\n"
      @cards = @cards[0,1] + @cards[-1,1] + @cards[1..-2]
      i = 1
    end
    return i
    puts "D: #{@cards.join(" ")}"
    puts "======================================"
  end

  def triple_cut
    jokers = [@cards.index("A"), @cards.index("B")]
    top, bot = jokers.min, jokers.max
    @cards = @cards[(bot+1)..-1] + @cards[top..bot] + @cards[0..top]
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts @cards.join(" ")
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    # ia = tcl.find_index("A").to_i
    # ib = tcl.find_index("B").to_i
    # # slices
    # if ia < ib
    #   top = tcl.slice(0, ia)
    #   mid = tcl.slice(ia, ib - ia + 1)
    #   bot = tcl.slice(ib, tcl.length - ib)
    #   # puts "top: #{top}, mid: #{mid}, bot: #{bot}"
    # else
    #   top = tcl.slice(0, ib)
    #   mid = tcl.slice(ib, ia - ib + 1)
    #   bot = tcl.slice(ia, tcl.length - ia)
    #   # puts "!!top: #{top}, mid: #{mid}, bot: #{bot}"
    # end
    # @cards = []
    # if bot[0] == "A" || bot[0] == "B"
    #   @cards << mid << top
    # else
    #   @cards << bot << mid << top
    # end
    # puts @cards.join " "
  end

  def count_cut
    unless @cards[0][-1] == "A" || @cards[0][-1] == "B"
      i = @cards[0][-1].to_i
      cut = @cards.slice(0, i)
      # puts cut.join(" ")
      rest = @cards.slice(i+1, @cards.length - i - 1)
      @cards = rest + cut + [@cards[0][-1]]
    end
  end

  def get_number
    @cards.flatten!
    # puts "#{@cards[0][]}: i+1: #{@cards[1]}"
    @cards[0] =~ /A|B/ ? @cards[1] : @cards[0]
  end

end

d = Deck.new "Code in Ruby, live longer!"
d.encrypt_deck