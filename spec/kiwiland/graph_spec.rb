require "spec_helper"

module Kiwiland
  RSpec.describe Graph do
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
        expect(graph.distance_between("A", "E", "D")).to eq(NoRouteExists)
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
end
