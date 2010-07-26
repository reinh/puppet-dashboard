describe "with search by q and tag", :shared => true do
  before do
    @for_tag = model.generate(:name => 'for_tag')
    @for_q = model.generate(:name => 'for_q')
    model.generate(:name => 'without_search')
  end

  describe "without a search" do
    before { get 'index' }
    subject { assigns[model.name.tableize] }

    it "returns all node groupes" do
      should == model.all
    end
  end

  describe "with a 'tag' search" do
    before { get 'index', :tag => 'for_tag' }
    subject { assigns[model.name.tableize] }

    it "returns node groupes whose name contains the term" do
      subject.all?{|item| item.name.include?('for_tag')}.should be_true
    end

    it "does not return node groups whose name does not contain the term" do
      subject.any?{|item| item.name.include?('for_q')}.should be_false
    end
  end

  describe "with a 'q' search" do
    before { get 'index', :q => 'for_q' }
    subject { assigns[model.name.tableize] }

    it "returns node groupes whose name contains the term" do
      subject.all?{|item| item.name.include?('for_q')}.should be_true
    end

    it "does not return node groups whose name does not contain the term" do
      subject.any?{|item| item.name.include?('for_tag')}.should be_false
    end
  end
end

describe "without JSON pagination", :shared => true do
  describe "GET index" do
    describe "as HTML" do
      before { get 'index', :format => 'html' }
      subject { assigns[model.name.tableize] }

      # NOTE: Once upon a time, the collection was paginated until it was realized that this broke the charts.
      # it "paginates by the page parameter" do
        # should be_a_kind_of(WillPaginate::Collection)
      # end

      it "does not paginate" do
        should_not be_a_kind_of(WillPaginate::Collection)
      end
    end

    describe "as JSON" do
      before { get 'index', :format => 'json' }
      subject { assigns[model.name.tableize] }

      it "does not paginate" do
        should_not be_a_kind_of(WillPaginate::Collection)
      end
    end
  end
end

