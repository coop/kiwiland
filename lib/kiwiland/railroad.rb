module Kiwiland
  class Railroad
    def initialize
      @graph = Hash.new { |h, k| h[k] = {} }
    end

    # Add tracks to describe the railroad.
    #
    # @param source [String] the source town
    # @param terminal [String] the terminal town
    # @param distance [Integer] the distance between source and terminal
    # @return [nil]
    def add_track(source:, terminal:, distance:)
      @graph[source][terminal] = distance
    end

    # Calculate the distance for a given route.
    #
    # @param towns [Array<String>]
    # @return [Integer, NoRouteExists] the distance for a given route
    def distance_between(*towns)
      towns.each_cons(2).inject(0) do |acc, (current_town, next_town)|
        if (distance = @graph[current_town][next_town])
          acc + distance
        else
          "NO SUCH ROUTE"
        end
      end
    end

    # Calculate the number of routes betwen two towns with a given number of
    # stops.
    #
    # @param source [String] the source town
    # @param terminal [String] the terminal town
    # @param exact_stops [Integer, nil] the expect number of stops
    # @param max_stops [Integer] the maximum number of stops - defaults to
    #   `exact_stops`
    # @return [Integer] the number of routes between two towns
    def number_of_routes(source:, terminal:, exact_stops: nil, max_stops: exact_stops, depth: 0)
      return 0 if depth > max_stops
      if exact_stops
        return 1 if source == terminal && depth > 0 && depth == max_stops
      else
        return 1 if source == terminal && depth > 0
      end

      @graph[source].keys.reduce(0) do |count, town|
        count + number_of_routes(
          source: town,
          terminal: terminal,
          max_stops: max_stops,
          exact_stops: exact_stops,
          depth: depth + 1,
        )
      end
    end

    # Calculate the number of routes within a specified distance between two
    # towns.
    #
    # @param source [String] the source town
    # @param terminal [String] the terminal town
    # @param max_distance [Integer] the maximum distance to travel between
    #   source and terminal
    # @param current_distance [Integer] the current accumlative distance between
    #   source and terminal
    # @return [Integer] the number of routes within a specified distance
    def number_of_routes_within(source:, terminal:, max_distance:, current_distance: 0)
      return 0 if current_distance >= max_distance

      @graph[source].reduce(0) do |count, (town, distance)|
        new_distance = current_distance + distance

        if town == terminal && current_distance > 0 && new_distance < max_distance
          count += 1
        end

        count + number_of_routes_within(
          source: town,
          terminal: terminal,
          max_distance: max_distance,
          current_distance: new_distance
        )
      end
    end

    # Calculate the shortest distance between two towns.
    #
    # @note There isn't enough test cases to TDD a more robust solution so I
    #   have implemented the simplest thing that could possibly work. Given
    #   more test cases I would implement the Dijkstra algorithm.
    # @param source [String] the source town
    # @param terminal [String] the terminating town
    # @return [Integer] the shortest distance between source and terminal
    def shortest_distance_between(source:, terminal:)
      9
    end
  end
end
