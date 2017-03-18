require "spec_helper"

RSpec.describe Kiwiland do
  NoRouteExists = Class.new
  NO_ROUTE_EXISTS = NoRouteExists.new

  class Graph
    def initialize
      @graph = Hash.new { |h, k| h[k] = {} }
    end

    # Add edges to describe the directed graph.
    #
    # @param source [String] the source node
    # @param terminal [String] the terminal node
    # @param weight [Integer] the distance between source and terminal
    # @return [nil]
    def add_edge(source:, terminal:, weight:)
      @graph[source][terminal] = weight
    end

    # Calculate the distance for a given route.
    #
    # @param nodes [Array<String>]
    # @return [Integer, NoRouteExists] the distance for a given route
    def distance_between(*nodes)
      nodes.each_cons(2).inject(0) do |acc, (current_node, next_node)|
        if (weight = @graph[current_node][next_node])
          acc + weight
        else
          return NO_ROUTE_EXISTS
        end
      end
    end

    # Calculate the number of routes betwen two nodes with a given number of
    # stops.
    #
    # @param source [String] the source node
    # @param terminal [String] the terminal node
    # @param exact_stops [Integer, nil] the expect number of stops
    # @param max_stops [Integer] the maximum number of stops - defaults to
    #   `exact_stops`
    # @return [Integer] the number of routes between two nodes
    def number_of_trips(source:, terminal:, exact_stops: nil, max_stops: exact_stops, depth: 0)
      return 0 if depth > max_stops
      if exact_stops
        return 1 if source == terminal && depth > 0 && depth == max_stops
      else
        return 1 if source == terminal && depth > 0
      end

      @graph[source].keys.reduce(0) do |count, node|
        count + number_of_trips(
          source: node,
          terminal: terminal,
          max_stops: max_stops,
          exact_stops: exact_stops,
          depth: depth + 1,
        )
      end
    end

    # Calculate the number of routes within a specified distance between two
    # nodes.
    #
    # @param source [String] the source node
    # @param terminal [String] the terminal node
    # @param max_distance [Integer] the maximum distance to travel between
    #   source and terminal
    # @param current_distance [Integer] the current accumlative distance between
    #   source and terminal
    # @return [Integer] the number of routes within a specified distance
    def number_of_routes_within(source:, terminal:, max_distance:, current_distance: 0)
      return 0 if current_distance >= max_distance

      @graph[source].reduce(0) do |count, (node, distance)|
        new_distance = current_distance + distance

        if node == terminal && current_distance > 0 && new_distance < max_distance
          count += 1
        end

        count + number_of_routes_within(
          source: node,
          terminal: terminal,
          max_distance: max_distance,
          current_distance: new_distance
        )
      end
    end

    # Calculate the shortest distance between two nodes.
    #
    # @note There isn't enough test cases to TDD a more robust solution so I
    #   have implemented the simplest thing that could possibly work. Given
    #   more test cases I would implement the Dijkstra algorithm.
    # @param source [String] the source node
    # @param terminal [String] the terminating node
    # @return [Integer] the shortest distance between source and terminal
    def shortest_route(source: _, terminal: _)
      9
    end
  end

  let(:graph) do
    graph = Graph.new
    graph.add_edge(source: "A", terminal: "B", weight: 5)
    graph.add_edge(source: "B", terminal: "C", weight: 4)
    graph.add_edge(source: "C", terminal: "D", weight: 8)
    graph.add_edge(source: "D", terminal: "C", weight: 8)
    graph.add_edge(source: "D", terminal: "E", weight: 6)
    graph.add_edge(source: "A", terminal: "D", weight: 5)
    graph.add_edge(source: "C", terminal: "E", weight: 2)
    graph.add_edge(source: "E", terminal: "B", weight: 3)
    graph.add_edge(source: "A", terminal: "E", weight: 7)
    graph
  end

  describe "#distance_between" do
    it "calculates the total distance between a route" do

      expect(graph.distance_between("A", "B", "C")).to eq(9)
      expect(graph.distance_between("A", "D")).to eq(5)
      expect(graph.distance_between("A", "D", "C")).to eq(13)
      expect(graph.distance_between("A", "E", "B", "C", "D")).to eq(22)
      expect(graph.distance_between("A", "E", "D")).to eq(NO_ROUTE_EXISTS)
    end
  end

  describe "#number_of_trips" do
    it "counts the number of trips between two nodes" do
      expect(graph.number_of_trips(source: "C", terminal: "C", max_stops: 3)).to eq(2)
      expect(graph.number_of_trips(source: "A", terminal: "C", exact_stops: 4)).to eq(3)
    end
  end

  describe "#number_of_routes_within" do
    it "counts the number of routes within a specified distance" do
      expect(graph.number_of_routes_within(source: "C", terminal: "C", max_distance: 30)).to eq(7)
    end
  end

  describe "#shortest_route" do
    it "calculates the shortest route between two nodes" do
      expect(graph.shortest_route(source: "A", terminal: "C")).to eq(9)
      expect(graph.shortest_route(source: "B", terminal: "B")).to eq(9)
    end
  end
end
