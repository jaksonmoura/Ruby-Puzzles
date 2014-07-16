class Tourist

  def initialize
    @input = File.open("input.txt")
    @file = []
    @input.each { |i| @file << i.chomp }
    @file.delete_if {|f| f == "" }
    @file.reverse!
  end

  def get_flights
    n = @file.pop.to_i
    n.times do # Number of examples in the file
      f_times = @file.pop.to_i
      flights = []

      f_times.times do # First loop to get flights
        flights << make_array(@file.pop)
      end
      # Return the apropriate flight times
      best_flight(flights)
    end
  end

  private

  # def best_flight(flights)
  #   [:cheap_flight, :fast_flight].each do |flight_type|
  #     from, to = "A", "Z"
  #     report = ""
  #     path = []
  #     total, @t_travelled = 0.0, 0
  #     @depart, arrive = nil, nil
  #     n = flights.group_by {|f| f[:from] }.size
  #     n.times do
  #       # Verify only if they're on a city they didn't pass
  #       unless path.include?(from)

  #         # Gets only flights where origin is "A" or the last destination
  #         # and "bigger" than previous city
  #         current_flights = flights.select { |f| f[:from] == from && f[:to] > f[:from] }
  #         best_trip = nil
  #         current_flights.each { |cf| best_trip = send(:fast_flight, cf, best_trip) }

  #         @t_travelled += best_trip[:arrive] - best_trip[:depart]
  #         depart = best_trip[:depart] if best_trip[:from] == "A"
  #         arrive = best_trip[:arrive] if best_trip[:to] == "Z"
  #         total += best_trip[:price]
  #         puts "!!!!!!!!!!!!!!!!!!!!!!!"
  #         puts total

  #         # Next trip origin | Include cities passed to path
  #         path << from
  #         from = best_trip[:to]
  #       # else
  #         # report = "#{depart} #{arrive} #{total}"
  #       end
  #     end
  #   end
  #   puts report
  #   # return report
  # end

  def self.find_best_trip(graph, from, to, compare, path = [], trip = nil, flight = nil)
    path << from
    trip = { depart: nil, arrive: 0, price: 0 } if trip.nil? # Initialize trip summary
    unless flight.nil?
      # Add on to the trip summary with flight data from the current node in the graph
      trip[:depart] = flight[:depart] if trip[:depart].nil?
      trip[:arrive] = flight[:arrive]
      trip[:price] += flight[:price]
    end
    return trip if from == to # Reached the destination node so return the trip summary
    best_trip = nil
    graph[from].each do |flight|
      # Try each valid path through the graph, potentially selecting a new best trip
      unless path.include?(flight[:to]) || flight[:depart] < trip[:arrive]
        new_trip  = find_best_trip(graph, flight[:to], to, compare, path.dup, trip.dup, flight)
        best_trip = send(compare, new_trip, best_trip)
      end
    end
    best_trip
  end

  def fast_flight(trip1, trip2)
    return trip1 if trip2.nil?
    return trip2 if trip1.nil?
    case trip1[:arrive] - trip1[:depart] <=> trip2[:arrive] - trip2[:depart]
      when -1 then trip1
      when  0 then cheap_flight(trip1, trip2)
      when  1 then trip2
    end
  end

  def cheap_flight(trip1, trip2)
    return trip1 if trip2.nil?
    return trip2 if trip1.nil?
    case trip1[:price] <=> trip2[:price]
      when -1 then trip1
      when  0 then fast_flight(trip1, trip2)
      when  1 then trip2
    end
  end

  def make_array(s)
    { :from => s.split[0],
      :to => s.split[1],
      :depart => s.split[2].sub(":", "").to_i,
      :arrive => s.split[3].sub(":", "").to_i,
      :price => s.split[4].to_f
    }
  end

end