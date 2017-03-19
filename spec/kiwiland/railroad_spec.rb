require "spec_helper"

module Kiwiland
  RSpec.describe Railroad do
    let(:railroad) do
      railroad = Railroad.new
      railroad.add_track(source: "A", terminal: "B", distance: 5)
      railroad.add_track(source: "B", terminal: "C", distance: 4)
      railroad.add_track(source: "C", terminal: "D", distance: 8)
      railroad.add_track(source: "D", terminal: "C", distance: 8)
      railroad.add_track(source: "D", terminal: "E", distance: 6)
      railroad.add_track(source: "A", terminal: "D", distance: 5)
      railroad.add_track(source: "C", terminal: "E", distance: 2)
      railroad.add_track(source: "E", terminal: "B", distance: 3)
      railroad.add_track(source: "A", terminal: "E", distance: 7)
      railroad
    end

    describe "#distance_between" do
      it "calculates the total distance between a route" do

        expect(railroad.distance_between("A", "B", "C")).to eq(9)
        expect(railroad.distance_between("A", "D")).to eq(5)
        expect(railroad.distance_between("A", "D", "C")).to eq(13)
        expect(railroad.distance_between("A", "E", "B", "C", "D")).to eq(22)
        expect(railroad.distance_between("A", "E", "D")).to eq("NO SUCH ROUTE")
      end
    end

    describe "#number_of_routes" do
      it "counts the number of routes between two towns" do
        expect(railroad.number_of_routes(source: "C", terminal: "C", max_stops: 3)).to eq(2)
        expect(railroad.number_of_routes(source: "A", terminal: "C", exact_stops: 4)).to eq(3)
      end
    end

    describe "#number_of_routes_within" do
      it "counts the number of routes within a specified distance" do
        expect(railroad.number_of_routes_within(source: "C", terminal: "C", max_distance: 30)).to eq(7)
      end
    end

    describe "#shortest_distance" do
      it "calculates the shortest distance between two towns" do
        expect(railroad.shortest_distance_between(source: "A", terminal: "C")).to eq(9)
        expect(railroad.shortest_distance_between(source: "B", terminal: "B")).to eq(9)
      end
    end
  end
end
