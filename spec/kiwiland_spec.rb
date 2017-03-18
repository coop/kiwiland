require "spec_helper"

RSpec.describe Kiwiland do
  NoRouteExists = Class.new
  NO_ROUTE_EXISTS = NoRouteExists.new

  class Graph
    def initialize
      @graph = Hash.new { |h, k| h[k] = {} }
    end

    def add_edge(source, terminal, weight)
      @graph[source][terminal] = weight
    end

    def distance_between(*nodes)
      nodes.each_cons(2).inject(0) do |accum, (current_node, next_node)|
        if (weight = @graph[current_node][next_node])
          accum + weight
        else
          return NO_ROUTE_EXISTS
        end
      end
    end
  end

  let(:graph) do
    graph = Graph.new
    graph.add_edge("A", "B", 5)
    graph.add_edge("B", "C", 4)
    graph.add_edge("C", "D", 8)
    graph.add_edge("D", "C", 8)
    graph.add_edge("D", "E", 6)
    graph.add_edge("A", "D", 5)
    graph.add_edge("C", "E", 2)
    graph.add_edge("E", "B", 3)
    graph.add_edge("A", "E", 7)
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
end
