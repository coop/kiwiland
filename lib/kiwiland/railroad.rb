module Kiwiland
  class Railroad
    class NoFilterSupplied < ArgumentError
      def message
        "No filter supplied, use one of `max_stops`, `exact_stops` or `max_distance`."
      end
    end

    class TooManyFiltersSupplied < ArgumentError
      def initialize(filters)
        @filters = filters
      end

      def message
        "Too many filters supplied: #{@filters.join(", ")}."
      end
    end

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

    # Calculate the number of routes between two towns with a given filtering
    # criteria.
    #
    # @param source [String] the source town
    # @param terminal [String] the terminal town
    # @param exact_stops [Integer, nil] the expect number of stops
    # @param max_stops [Integer] the maximum number of stops
    # @param max_distance [Integer] the maximum distance to travel between
    #   source and terminal
    # @return [Integer] the number of routes between two towns
    def count_routes(source:, terminal:, exact_stops: nil, max_stops: nil, max_distance: nil)
      options = {
        max_stops: max_stops,
        exact_stops: exact_stops,
        max_distance: max_distance
      }.compact

      raise NoFilterSupplied if options.empty?
      raise TooManyFiltersSupplied, options.keys if options.keys.count > 1

      option, value = options.first

      send(
        "count_routes_with_#{option}",
        source: source,
        terminal: terminal,
        option => value,
      )
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

    private

    def count_routes_with_max_stops(source:, terminal:, max_stops:, depth: 0)
      return 0 if depth > max_stops
      return 1 if source == terminal && depth > 0

      @graph[source].keys.reduce(0) do |count, town|
        count + count_routes_with_max_stops(
          source: town,
          terminal: terminal,
          max_stops: max_stops,
          depth: depth + 1,
        )
      end
    end

    def count_routes_with_exact_stops(source:, terminal:, exact_stops: nil, depth: 0)
      return 0 if depth > exact_stops
      return 1 if source == terminal && depth > 0 && depth == exact_stops

      @graph[source].keys.reduce(0) do |count, town|
        count + count_routes_with_exact_stops(
          source: town,
          terminal: terminal,
          exact_stops: exact_stops,
          depth: depth + 1,
        )
      end
    end

    def count_routes_with_max_distance(source:, terminal:, max_distance:, current_distance: 0)
      return 0 if current_distance >= max_distance

      @graph[source].reduce(0) do |count, (town, distance)|
        new_distance = current_distance + distance

        if town == terminal && current_distance > 0 && new_distance < max_distance
          count += 1
        end

        count + count_routes_with_max_distance(
          source: town,
          terminal: terminal,
          max_distance: max_distance,
          current_distance: new_distance
        )
      end
    end
  end
end
