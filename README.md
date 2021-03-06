# Kiwiland

[![Build Status](https://travis-ci.org/coop/kiwiland.svg?branch=master)](https://travis-ci.org/coop/kiwiland)

The local commuter railroad services a number of towns in Kiwiland.  Because of
monetary concerns, all of the tracks are 'one-way’. That is, a route from
Kaitaia to Invercargill does not imply the existence of a route from
Invercargill to Kaitaia. In fact, even if both of these routes do happen to
exist, they are distinct and are not necessarily the same distance!

The purpose of this problem is to help the railroad provide its customers with
information about the routes. In particular, you will compute the distance along
a certain route, the number of different routes between two towns, and the
shortest route between two towns.

Input: A directed graph where a node represents a town and an edge represents a
route between two towns. The weighting of the edge represents the distance
between the two towns. A given route will never appear more than once, and for a
given route, the starting and ending town will not be the same town.

Output: For test input 1 through 5, if no such route exists, output 'NO SUCH
ROUTE'. Otherwise, follow the route as given; do not make any extra stops! For
example, the first problem means to start at city A, then travel directly to
city B (a distance of 5), then directly to city C (a distance of 4).

1. The distance of the route A-B-C.
2. The distance of the route A-D.
3. The distance of the route A-D-C.
4. The distance of the route A-E-B-C-D.
5. The distance of the route A-E-D.
6. The number of trips starting at C and ending at C with a maximum of 3 stops.
    In the sample data below, there are two such trips: C-D-C (2 stops). and
    C-E-B-C (3 stops).
7. The number of trips starting at A and ending at C with exactly 4 stops.  In
    the sample data below, there are three such trips: A to C (via B,C,D); A to
    C (via D,C,D); and A to C (via D,E,B).
8. The length of the shortest route (in terms of distance to travel) from A to
    C.
9. The length of the shortest route (in terms of distance to travel) from B to
    B.
10. The number of different routes from C to C with a distance of less than 30.
    In the sample data, the trips are: CDC, CEBC, CEBCDC, CDCEBC, CDEBC,
    CEBCEBC, CEBCEBCEBC.

Test Input: For the test input, the towns are named using the first few letters
of the alphabet from A to D. A route between two towns (A to B) with a distance
of 5 is represented as AB5.

Graph: AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7

Expected Output:

```
Output #1: 9
Output #2: 5
Output #3: 13
Output #4: 22
Output #5: NO SUCH ROUTE
Output #6: 2
Output #7: 3
Output #8: 9
Output #9: 9
Output #10: 7
```

- There must be a way to supply the application with the input data via text
    file.
- The application must run and you should provide sufficient evidence that your
    solution is complete by, as a minimum, indicating that it works correctly
    against the supplied test data.
- The submission should be production quality and it can be done in any
    language (using JavaScript, Ruby or Go would be a bonus).
- You may not use any external libraries to solve this problem, but you may use
    external libraries or tools for building or testing purposes. Specifically,
    you may use unit testing libraries or build tools available for your chosen
    language.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "kiwiland"
```

And then execute:

    $ bundle

Or install it yourself locally (the gem is not available on rubygems):

    $ git clone git@github.com:coop/kiwiland.git
    $ cd kiwiland
    $ bundle exec rake install

## Usage

If you have installed the gem locally you can use the binary:

    $ kiwiland count-routes C C --max-distance 30
    7

Otherwise you can use the [non-executable binary included with the
gem](https://github.com/bundler/bundler/pull/2380):

    $ ruby -I lib -S exe/kiwiland count-routes C C --max-distance 30
    7

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/coop/kiwiland.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
