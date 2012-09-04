require 'spec_helper'

describe WilliamHill do
  subject { WilliamHill.new(43) }

  describe :methods do
    describe :get_sports do
      before :all do
        stub_request(:any, /.*/).to_return(:body => mock_output("sports.xml"))
        @sports = WilliamHill.get_sports
      end

      it "should return a hash" do
        @sports.class.should == Hash
      end

      it "should return the correct number of sports" do
        @sports.count.should == 80
      end

      it "should return the correct sports" do
        @sports.keys.should == ["American Football", "American Football Specials", "Baseball", "European Basketball", "International Cricket", "UK Domestic Cricket", "Darts", "Darts Specials", "UK Football", "International Football", "European Major Leagues", "Other League Football", "UEFA Club Competitions", "Football Specials", "Football - Virtual", "Golf Majors", "Mens Golf", "Golf Specials", "Greyhounds - Live", "Greyhound Hurdles - Virtual", "Greyhounds - Virtual", "Greyhounds - Trap Challenge", "Greyhounds - Antepost", "Greyhounds - Specials", "Horse Racing - Live", "Horse Racing Sprint - Virtual", "Horse National Hunt - Virtual", "Horse Racing - Antepost", "Horse Racing - Tote Pools", "Horse Racing - Specials", "NHL", "International Ice Hockey", "European Ice Hockey", "Formula 1", "Motor", "Speedway", "NASCAR", "Rally", "Moto GP", "Archery", "Athletics", "Badminton", "Beach Volleyball", "Boxing", "UFC / MMA", "Canoeing", "Cycling", "Cycling - Virtual", "Diving", "Equestrian", "Fencing", "GAA Football", "Gymnastics", "Handball", "Hockey", "GAA Hurling", "Judo", "Rowing", "Shooting", "Swimming", "Sync Swimming", "Table Tennis", "Triathlon", "Volleyball", "Water Polo", "Weightlifting", "Wrestling", "Yachting/Sailing", "Politics", "Rugby League", "Rugby Union", "Snooker", "TV Specials", "Other Specials", "Weather Specials", "Grand Slam Tennis", "Mens Tennis", "Womens Tennis", "Challenger Tennis", "Tennis Specials"] 
      end

      it "should return the correct ids" do
        @sports.values.should == ["19", "380", "15", "273", "42", "9", "335", "384", "1", "36", "46", "274", "275", "276", "436", "8", "40", "385", "3", "438", "330", "280", "17", "386", "2", "439", "442", "13", "38", "323", "32", "401", "283", "5", "412", "419", "285", "25", "420", "339", "295", "296", "342", "10", "402", "343", "301", "437", "344", "302", "345", "348", "22", "303", "304", "349", "350", "357", "358", "318", "360", "319", "362", "320", "321", "363", "364", "322", "52", "325", "7", "334", "37", "294", "293", "45", "43", "308", "424", "392"]
      end
    end
    
    describe "instance methods" do
      describe :get_competitions do
        before :all do
          stub_request(:any, /.*/).to_return(:body => mock_output("events.xml"))
          @events = subject.get_competitions
        end

        it "should return an Array" do
          @events.class.should == Array
        end

        it "should return the correct number of events" do
          @events.count.should == 2
        end

        it "should return the correct events" do
          @events.should == ["Olympics - Women&apos;s Basketball", "Olympics - Men&apos;s Basketball"]
        end
      end

      describe :get_markets do
        context "markets from all events" do
          before :all do
            stub_request(:any, /.*/).to_return(:body => mock_output("events.xml"))
            @markets = subject.get_markets
          end

          it "should return the correct number of markets" do
            @markets.count.should == 14
          end
        end

        context "markets from a given event" do
          before :all do
            stub_request(:any, /.*/).to_return(:body => mock_output("events.xml"))
            @markets = subject.get_markets(subject.get_competitions.first)
          end

          it "should return the correct markets" do
            @markets.should == ["China v Czech Republic - Money Line", "Russia v Canada - Money Line", "Canada v Russia - Money Line", "Turkey v Angola - Money Line", "USA v Croatia - Money Line", "France v Brazil - Money Line", "Brazil v France - Money Line", "Australia v Great Britain - Money Line"]
          end
        end
      end

      describe :get_odds do
        before :all do
          stub_request(:any, /.*/).to_return(:body => mock_output("events.xml"))
          @odds = subject.get_odds(subject.get_markets.first)
        end

        it "should return a hash with the odds" do
          @odds.should == [{:name=>"China", :odds=>"2.15"}, {:name=>"Czech Republic", :odds=>"1.62"}]
        end
      end

      describe :get_full_markets do
        before :all do
          stub_request(:any, /.*/).to_return(:body => mock_output("events.xml"))
          @full_markets = subject.get_full_markets
        end

        it "should parse correctly the id" do
          @full_markets.last[:id].should == "39371471"
        end

        it "should parse correctly the name" do
          @full_markets.last[:name].should == "Argentina v Lithuania - Money Line"
        end

        it "should parse correctly the odds" do
          @full_markets.last[:odds].should == [{:id=>"165143361", :name=>"Lithuania", :odds=>"2.25"}, {:id=>"165143364", :name=>"Argentina", :odds=>"1.57"}]
        end

        it "should parse correctly the time" do
          @full_markets.last[:time].should == "2012-07-29 21:15:00 UTC".to_time
        end

        it "should parse correctly the bet limit time" do
          @full_markets.last[:bet_limit_time].should == "2012-07-29 21:15:00 UTC".to_time
        end
      end
    end
  end
end
