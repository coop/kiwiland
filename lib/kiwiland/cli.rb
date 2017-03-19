require "thor"

module Kiwiland
  class CLI < Thor
    package_name "kiwiland"

    class_option :graph, type: :string, required: true, default: "AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7"

    def self.exit_on_failure?
      true
    end

    map %w(-v --version) => :version
    desc "version", "Show kiwiland version"
    def version
      require "kiwiland/version"
      say VERSION
    end

    desc "route-distance [SOURCE] [TERMINAL]", "Calculate the distance between two towns"
    def route_distance(*nodes)
      say graph.distance_between(*nodes)
    end

    desc "route-count [SOURCE] [TERMINAL]", "Calculate the number of routes between two towns"
    option "max-stops", type: :numeric, desc: "The maximum number of stops allowed between two towns"
    option "exact-stops", type: :numeric, desc: "The exact number of stops allowed between two towns"
    option "max-distance", type: :numeric, desc: "The maximum distance allowed between two towns"
    def route_count(source, terminal)
      if correct_number_of_options_for_route_count?(options)
        result =
          if options["max-distance"]
            graph.number_of_routes_within(
              source: source,
              terminal: terminal,
              max_distance: options["max-distance"],
            )
          else
            exact_stops = options["exact-stops"]
            graph.number_of_trips(
              source: source,
              terminal: terminal,
              exact_stops: options["exact-stops"],
              max_stops: options.fetch("max-stops") { exact_stops },
            )
          end
        say result
      else
        error "Incorrect number of options specified, specify one of `--max-stops`, `exact-stops` or `max-distance`"
        exit(1)
      end
    end

    desc "shortest-distance [SOURCE] [TERMINAL]", "Calculate the shortest route between two towns"
    def shortest_distance(source, terminal)
      say graph.shortest_route(source: source, terminal: terminal)
    end

    no_commands do
      def graph
        graph = Graph.new
        options[:graph].gsub(/\s/, "").scan(/(\w)(\w)(\d)/).each do |source, terminal, weight|
          graph.add_edge(source: source, terminal: terminal, weight: weight.to_i)
        end
        graph
      end

      # At this stage counting the number of routes is "dumb" and doesn't
      # understand multiple conditions, ideally the following would be possible:
      #
      # - find the number of routes with a max distance of 30 and max stops 3
      # - find the number of routes with exactly 3 stops and a max distance of 9
      #
      # `graph` is a required option and we expect exactly 1 other option
      # otherwise the request is invalid.
      def correct_number_of_options_for_route_count?(options)
        options.keys.length == 2
      end
    end
  end
end
