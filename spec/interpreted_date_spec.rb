require 'spec_helper'

describe InterpretedDate do

  describe "with no date attributes" do
    subject { InterpretedDate.new }

    it "returns nil string" do
      subject.to_s.should be_nil
    end

    it "returns nil integer" do
      subject.to_i.should be_nil
    end
  end

  describe "with decade only" do
    subject { InterpretedDate.new({:decade => 1950}) }

    it "returns the right string" do
      subject.to_s.should eq("1950s")
    end

    it "optionally returns a string with a preposition" do
      subject.to_s(preposition: true).should eq("in the 1950s")
    end

    it "returns the right integer" do
      subject.to_i.should eq(Date.new(1955).to_time.to_i)
    end
  end

  describe "with decade and year" do
    subject { InterpretedDate.new({:decade => 1950, :year => 1954}) }

    it "returns the right string" do
      subject.to_s.should eq("1954")
    end

    it "optionally returns a string with a preposition" do
      subject.to_s(preposition: true).should eq("in 1954")
    end

    it "returns the right integer" do
      subject.to_i.should eq(Date.new(1954).to_time.to_i)
    end
  end

  describe "with decade, year and month" do
    subject { InterpretedDate.new({:decade => 1950, :year => 1955, :month => 3}) }

    it "returns the right string" do
      subject.to_s.should eq("March 1955")
    end

    it "returns the right integer" do
      subject.to_i.should eq(Date.new(1955, 3).to_time.to_i)
    end

    it "returns the right string with a preposition" do
      subject.to_s(preposition: true).should eq("in March 1955")
    end

  end

  describe "with decade, year, month and day" do
    subject { InterpretedDate.new({:decade => 1950, :year => 1955, :month => 3, :day => 1}) }

    it "returns the right string" do
      subject.to_s.should eq("March 1, 1955")
    end

    it "returns the right integer" do
      subject.to_i.should eq(Date.new(1955, 3, 1).to_time.to_i)
    end

    it "returns the right string with a preposition" do
      subject.to_s(preposition: true).should eq("on March 1, 1955")
    end

  end

  describe "with month and day" do
    subject { InterpretedDate.new({:month => 10, :day => 31}) }

    it "returns the right string" do
      subject.to_s.should eq("October 31")
    end

    it "returns nil integer" do
      subject.to_i.should be_nil
    end

    it "returns the right string with a preposition" do
      subject.to_s(preposition: true).should eq("on October 31")
    end

  end

  describe "with invalid date" do
    subject { InterpretedDate.new({:year => 2012, :month => 2, :day => 31}) }

    it "returns nil string" do
      subject.to_s.should be_nil
    end

    it "returns nil integer" do
      subject.to_i.should be_nil
    end
  end

  describe "#from_json" do
    subject { InterpretedDate.new({:year => 2012, :month => 2, :day => 31}) }

    it "correctly parses the json" do
      InterpretedDate.from_json('year' => 2012, 'month' => 2, 'day' => 31).should == subject
    end

    it "correctly parses dates where values are strings" do
      InterpretedDate.from_json('year' => 2012, 'month' => '2', 'day' => 31).should == subject
    end

    it "correctly parses date where the month is given by name" do
      InterpretedDate.from_json('year' => 2012, 'month' => 'February', 'day' => 31).should == subject
    end

    it "correctly parses date where the month is given by abbreviated name" do
      InterpretedDate.from_json('year' => 2012, 'month' => 'Feb', 'day' => 31).should == subject
    end

    it "gracefully handles a nil JSON" do
      InterpretedDate.from_json(nil).should == InterpretedDate.new
    end
  end

  describe "<=>" do

    it "correctly sorts with a decade" do
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2000 })).should == 1
      (InterpretedDate.new({:decade => 1950, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2000 })).should == -1
      (InterpretedDate.new({:decade => 1950, :month => 2}) <=> InterpretedDate.new({:decade => 1950, :month => 10 })).should == -1
      (InterpretedDate.new({:decade => 1950}) <=> InterpretedDate.new({:decade => 1950})).should == 0
    end

    it "correctly sorts with the year" do
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2010, :year => 2011 })).should == 1
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2010, :year => 2013 })).should == -1
      (InterpretedDate.new({:decade => 2010, :year => 2012}) <=> InterpretedDate.new({:decade => 2010, :year => 2012})).should == 0
    end

    it "correctly sorts with the month" do
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2010, :year => 2011, :month => 1 })).should == 1
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2010, :year => 2013, :month => 3 })).should == -1
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 3}) <=> InterpretedDate.new({:decade => 2010, :year => 2012, :month => 3})).should == 0
    end

    it "correctly sorts with the month nil" do
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2}) <=> 
        InterpretedDate.new({:decade => 2010, :year => 2012, :month => nil})).should == 1
    end

    it "correctly sorts with the day" do
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2010, :year => 2011, :month => 2, :day => 1 })).should == 1
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 15}) <=> InterpretedDate.new({:decade => 2010, :year => 2013, :month => 2, :day => 31 })).should == -1
      (InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31}) <=> InterpretedDate.new({:decade => 2010, :year => 2012, :month => 2, :day => 31})).should == 0
    end
  end

end