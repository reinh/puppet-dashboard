require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  describe "#require_user" do
    describe "when the App does not have authentication" do
      before { App.authenticate = false }
      subject { ApplicationController.new.send :require_user }

      it { should be_nil }
    end
  end

  describe "#require_no_user" do
    describe "when the App does not have authentication" do
      before { App.authenticate = false }
      subject { ApplicationController.new.send :require_no_user }

      it { should be_nil }
    end
  end

end
