class Door
  attr_reader :state

  def initialize
    @state = :closed
  end

  def close
    @state = :closed
  end

  def open
    @state = :open
  end

  def closed?
    @state == :closed
  end

  def toggle
    closed? ? open : close
  end

  def state
    @state.to_s
  end

end

doors = Array.new(100) { Door.new }
1.upto(100) do |n|
  doors.each_with_index do |d, i|
    d.toggle if (i + 1) % n == 0
  end
end

doors.each_with_index do |d,i|
  puts "Door #{(i + 1)} is #{d.state}"
end