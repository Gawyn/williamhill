williamhill
===========

WilliamHill is a wrapper for the William Hill "API". With it, you can easily access to all the data of the events offered by William Hill.

Basic Usage
-----------
To use the gem, first install it or add it to your Gemfile.
  
    gem 'williamhill'
    
For extracting the data, first we need to decide which kind of events we want to check. William Hill offers events in all kind of sports. For that, the gem offers the class method `get_sports` that returns a Hash with the name of the event types as key and the id as value.

    > WilliamHill.get_sports
    => {"American Football"=>"19", "Baseball"=>"15", "US Basketball"=>"336", "European Basketball"=>"273", "International Cricket"=>"42", "UK Domestic Cricket"=>"9", "Cricket Specials"=>"383", "Darts"=>"335", "UK Football"=>"1", "International Football"=>"36", "European Major Leagues"=>"46", "Other League Football"=>"274", "UEFA Club Competitions"=>"275", "Football Specials"=>"276", "Football - Virtual"=>"436", "Golf Majors"=>"8", "Mens Golf"=>"40", "Cycling"=>"301", "Seniors Golf"=>"39", "Womens Golf"=>"277", "Golf Specials"=>"385", "Greyhounds - Live"=>"3", "Greyhound Hurdles - Virtual"=>"438", "Greyhounds - Virtual"=>"330", "US Greyhound Racing"=>"331", "Greyhounds - Antepost"=>"17", "Greyhounds - Specials"=>"386", "Horse Racing - Live"=>"2", "Horse Racing Sprint - Virtual"=>"439", "Horse National Hunt - Virtual"=>"442", "Horse Racing - Antepost"=>"13", "US Harness Racing"=>"333", "US Thoroughbred Racing"=>"332", "Horse Racing - Specials"=>"323", "NHL"=>"32", "International Ice Hockey"=>"401", "European Ice Hockey"=>"283", "Formula 1"=>"5", "Motor"=>"412", "Speedway"=>"419", "Moto GP"=>"420", "Athletics"=>"295", "Australian Rules"=>"18", "Boxing"=>"10", "UFC / MMA"=>"402", "Cycling - Virtual"=>"437", "GAA Football"=>"348", "Handball"=>"303", "GAA Hurling"=>"349", "Volleyball"=>"320", "Politics"=>"52", "Rugby League"=>"325", "Rugby Union"=>"7", "Snooker"=>"334", "TV Specials"=>"37", "Other Specials"=>"294", "Music Specials"=>"292", "Weather Specials"=>"293", "Grand Slam Tennis"=>"45", "Womens Tennis"=>"308", "Challenger Tennis"=>"424", "Tennis Specials"=>"392"}

Once we have chosen the events type, you have to create a WilliamHill object using its id. For example, `WilliamHill.new(19)` would create an object with all the information on American Football.

Getting Information
-------------------

Williamhill offers you plenty of ways to get the information. The most exhaustive one is the `get_full_markets` method. It will return all the markets offered by William Hill, with the following data:

+ Id of the market in William Hill
+ Name of the market
+ Participants of the bet

Each participant includes:

+ William Hill id
+ Name of the participant
+ Winning odds

One example:

    > williamhill.get_full_markets("Spanish La Liga Primera")
    => [{:id=>"43594787", :name=>"Valladolid v Real Betis - Match Betting", :odds=>[{:id=>"180951959", :name=>"Valladolid", :odds=>"2.05"}, {:id=>"180951960", :name=>"Draw", :odds=>"3.40"}, {:id=>"180951961", :name=>"Real Betis", :odds=>"3.60"}], :time=>2012-09-17 19:30:00 UTC, :bet_limit_time=>2012-09-17 19:30:00 UTC}, ...]

You can use `get_full_markets` without any parameters, in which case it will return all the markets for the given event type or with the name of a competition, in which case it will return all the markets for that competition.

Other methods to exploit the WH data are `get_competitions`, `get_markets` and `get_participants(market)`.
