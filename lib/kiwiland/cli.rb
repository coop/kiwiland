require "thor"

module Kiwiland
  class CLI < Thor
    package_name "kiwiland"

    class_option :railroad,
      type: :string,
      required: true,
      default: "AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7"

    map %w(-v --version) => :version
    desc "version", "Show kiwiland version"
    def version
      require "kiwiland/version"
      say(VERSION)
    end

    desc "route-distance [SOURCE] [TERMINAL]", "Calculate the distance between two towns"
    def route_distance(*towns)
      say(railroad.distance_between(*towns))
    end

    desc "count-routes [SOURCE] [TERMINAL]", "Calculate the number of routes between two towns"
    option "max-stops", type: :numeric, desc: "The maximum number of stops allowed between two towns"
    option "exact-stops", type: :numeric, desc: "The exact number of stops allowed between two towns"
    option "max-distance", type: :numeric, desc: "The maximum distance allowed between two towns"
    def count_routes(source, terminal)
      say(
          railroad.count_routes(
          source: source,
          terminal: terminal,
          max_stops: options["max-stops"],
          exact_stops: options["exact-stops"],
          max_distance: options["max-distance"],
        ),
      )
    rescue => e
      error(e.message)
      exit(1)
    end

    desc "shortest-distance [SOURCE] [TERMINAL]", "Calculate the shortest distance between two towns"
    def shortest_distance(source, terminal)
      say(
        railroad.shortest_distance_between(
          source: source,
          terminal: terminal,
        ),
      )
    end

    no_commands do
      def railroad
        tracks = options[:railroad].gsub(/\s/, "").scan(/(\w)(\w)(\d)/)
        railroad = Railroad.new
        tracks.each do |source, terminal, distance|
          railroad.add_track(
            source: source,
            terminal: terminal,
            distance: distance.to_i,
          )
        end
        railroad
      end
    end
  end
end
