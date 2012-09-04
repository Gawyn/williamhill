require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext'

class WilliamHill
  attr_reader :class_id, :market_type, :live, :xml

  def initialize(class_id, options = nil)
    @class_id = class_id
    process_options(options) if options
    url = generate_url

    begin
      @xml = Nokogiri::XML(@load_from_local || open(url))
      process_filters
    rescue
    end
  end

  def self.get_sports
    sports_url = "http://whdn.williamhill.com/pricefeed/openbet_cdn?action=template"
    sports_xml = Nokogiri::XML(open(sports_url))
    sports_xml.search("class").inject({}) do |res, value|
      res.merge( { value.get_attribute("name") => value.get_attribute("id") } )
    end
  end

  def get_competitions
    @competitions ||= @xml.search("type").map { |value| value.get_attribute("name") }
  end

  def get_markets(event = nil)
    xml_part = event ? @xml.search("type[name='#{event}']") : @xml
    xml_part.search("market").map do |market|
      market.get_attribute("name")
    end
  end

  def get_odds(market)
    xml_part = @xml.search("market[name='#{market}']")
    xml_part.search("participant").map do |participant|
      { :name => participant[:name], :odds => participant[:oddsDecimal] }    
    end
  end

  def get_full_markets(event = nil)
    xml_part = event ? @xml.search("type[name='#{event}']") : @xml
    xml_part.search("market").map do |market|
      id = market.get_attribute("id")
      name = market.get_attribute("name")
      time = "#{market.get_attribute("date")} #{market.get_attribute("time")} +1".to_time
      bet_limit_time = "#{market.get_attribute("betTillDate")} #{market.get_attribute("betTillTime")} +1".to_time

      odds = market.search("participant").map do |participant|
        { :id => participant[:id], :name => participant[:name], :odds => participant[:oddsDecimal] }    
      end

      { :id => id, :name => name, :odds => odds, :time => time, :bet_limit_time => bet_limit_time }
    end
  end

  private

  def generate_url
    params = {
      :action => "template",
      :template => "getHierarchyByMarketType",
      :classId => @class_id
    }

    params[:marketSort] = @market_type if @market_type
    params[:filterBIR] = @live ? "Y" : "N" unless @live.nil?

    "http://whdn.williamhill.com/pricefeed/openbet_cdn?#{params.to_query}"
  end

  def process_options(options)
    @market_type = options[:market_type] if options.has_key?(:market_type)
    @live = options[:live] if options.has_key?(:live) && !!options[:live] == options[:live]
    @filters = options[:filters] if options.has_key?(:filters)
    @load_from_local = options[:load_from_local] if options.has_key?(:load_from_local)
  end

  def process_filters
    @xml.xpath(generate_filtering_xpath).remove if @filters.present?
  end

  def generate_filtering_xpath
    sentence = "//market[not(contains(@name, '"
    sentence += @filters[0..-2].map do |filter|
      "#{filter}') or contains(@name, '"
    end.join
    sentence += "#{@filters.last}'))]"

    sentence
  end
end
