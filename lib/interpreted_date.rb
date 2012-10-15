require "interpreted_date/version"

class InterpretedDate
  attr_accessor :decade, :year, :month, :day

  # Allows date strings to be generated with Ruby even for dates w/o years
  DEFAULT_YEAR = -1

  def initialize(attributes = {})
    self.decade = attributes[:decade]
    self.year = attributes[:year]
    self.month = attributes[:month]
    self.day = attributes[:day]
  end

  def self.from_date(date)
    new(year: date.year, month: date.month, day: date.day)
  end

  def decade=(value)
    @decade = value.to_i  if value
  end

  def year=(value)
    @year = value.to_i  if value
  end

  def month=(value)
    if value.to_i == 0
      if Date::ABBR_MONTHNAMES.index(value) && Date::ABBR_MONTHNAMES.index(value) > 0
        @month = Date::ABBR_MONTHNAMES.index(value)
      elsif Date::MONTHNAMES.index(value) && Date::MONTHNAMES.index(value) > 0 
        @month = Date::MONTHNAMES.index(value)
      end
    else
      @month = value.to_i
    end
  end

  def day=(value)
    @day = value.to_i  if value
  end

  def interpreted_year
    @interpreted_year ||= year || (decade && (decade + 5)) || DEFAULT_YEAR
  end

  def date_attributes
    return @date_attributes  if @date_attributes

    @date_attributes = [interpreted_year, month]
    @date_attributes << day  if month
    @date_attributes.compact!
    @date_attributes
  end

  def date
    @date ||= Date.new(*date_attributes)  if !date_attributes.empty?
  rescue Exception => e
    nil
  end

  def to_i
    date.to_time.to_i  if date && (decade || year)
  end

  def to_s(options = {})
    preposition = options.fetch(:preposition) { false }
    if day && month && year && date
      date.strftime("%B %-d, %Y")
    elsif month && year && date
      date.strftime("%B %Y")
    elsif year && date
      output = preposition ? "in " : ""
      output << date.strftime("%Y")
      output
    elsif decade
      output = preposition ? "in the " : ""
      output << decade.to_s
      output << "s"
      output
    elsif day && month && date
      date.strftime("%B %-d")
    end
  end

  def self.from_json(json)
    d = InterpretedDate.new
    d.decade = json['decade']
    d.year = json['year']
    d.month = json['month']
    d.day = json['day']
    d
  end

  def as_json(options = {})
    {
      'string' => self.to_s,
      'integer' => self.to_i,
      'decade' => decade,
      'year' => year,
      'month' => month,
      'day' => day,
    }
  end

  def self.interpret_date(date_string)
    date, specificity = DateTools.date_and_specificity(date_string)

    parts = {}

    return  unless specificity

    parts[:day] = date.day  if specificity <= 1
    parts[:month] = date.month  if specificity <= 2
    parts[:year] = date.year  if specificity <= 3
    parts[:decade] = date.year - (date.year % 10) if specificity <= 5

    new(parts)
  end

  def present?
    [decade, year, month, day].any?(&:present?)
  end

  def ==(other_date)
    self.decade == other_date.decade && self.year == other_date.year && self.month == other_date.month && self.day == other_date.day
  end

end