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
  end

  describe "with decade, year, month and day" do
    subject { InterpretedDate.new({:decade => 1950, :year => 1955, :month => 3, :day => 1}) }

    it "returns the right string" do
      subject.to_s.should eq("March 1, 1955")
    end

    it "returns the right integer" do
      subject.to_i.should eq(Date.new(1955, 3, 1).to_time.to_i)
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
      subject.should == InterpretedDate.from_json('year' => 2012, 'month' => 2, 'day' => 31)
    end

    it "correctly parses dates where values are strings" do
      subject.should == InterpretedDate.from_json('year' => 2012, 'month' => '2', 'day' => 31)
    end

    it "correctly parses date where the month is given by name" do
      subject.should == InterpretedDate.from_json('year' => 2012, 'month' => 'February', 'day' => 31)
    end

    it "correctly parses date where the month is given by abbreviated name" do
      subject.should == InterpretedDate.from_json('year' => 2012, 'month' => 'Feb', 'day' => 31)
    end
  end

end