require File.dirname(__FILE__) + '/../spec_helper'

describe "Recurrence, monthly" do

  def first_sunday_of_month_recurrence(date)
    Recurrence.new(date, :day_of_month => :sunday, :every => :first)
  end

  it "returns 02.03.2008 for the first sunday of a month on 02.03.2008" do
    rec = first_sunday_of_month_recurrence(Date.parse('2008-03-01'))

    rec.next[0].should == Date.parse('2008-03-02')
  end
  
  it "returns 06.04.2008 for months first sunday of a month on 03.03.2008" do
    rec = first_sunday_of_month_recurrence(Date.parse('2008-03-03'))
    rec.next[0].should == Date.parse('2008-04-06')
  end
  
end
