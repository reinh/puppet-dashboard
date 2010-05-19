require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  describe "#truncated_sentence" do
    describe "when there are less items than the max" do
      it "should return the items sentence" do
        helper.truncated_sentence(5, [1,2,3,4]).should == [1,2,3,4].to_sentence
      end
    end

    describe "when there are more items than the max" do
      it "should end with and n more" do
        helper.truncated_sentence(3, [1,2,3,4]).should include("and 1 more")
      end
    end

    describe "when given a block" do
      it "should map the items using the block" do
        helper.truncated_sentence(3, %w(a r)){|item| item.succ}.should == "b and s"
      end
    end

    it "should use the :more option" do
        helper.truncated_sentence(3, [1,2,3,4], :more => "%d extra").should include("and 1 extra")
    end

  end


end
