# puzzle form http://rosettacode.org/wiki/24_game

class Game24
  attr_reader :digits

  def initialize
    @digits = prompt_numbers
    puts "The numbers to be used are: #{@digits}"
  end

  def calc(operation)
    raise "Operation not allowed! only (+ - / *)" if operation.match(/([^\d\+\-\*\/\(\)\s])+/)
    confirm_numbers(get_numbers(operation))
    result = eval(operation)
    if result != 24
      raise "Result should be 24 but is was #{result}"
    else
      puts "#{result}! You Win!"
    end
  end

  private
  # Display the 4 numbers that can be used.
  def prompt_numbers
    numbers = []
    while numbers.size < 4 do
      numbers << rand(0..9)
      numbers.uniq!
    end
    return numbers.to_s
  end

  def get_numbers(operation)
    num = []
    operation.each_char { |o| num << o.to_i if o.match(/(\d)/) }
    raise "More than 4 number used. You only can use 4." if num.size != 4
    return num
  end

  def confirm_numbers(num)
    raise "Numbers should be the ones that were given (#{@digits})" if !num.all? { |n| @digits.include? n.to_s }
  end
end