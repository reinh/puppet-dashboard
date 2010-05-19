class NodesController < InheritedResources::Base
  belongs_to :node_class, :optional => true
  belongs_to :node_group, :optional => true
  respond_to :html, :yaml

  before_filter :require_user, :only => [:new, :edit, :update, :destroy, :create]

  layout lambda {|c| c.request.xhr? ? false : 'application' }

  def index
    index! do |format|
      # Do not paginate yaml
      format.yaml { render :text => Node.all.to_yaml, :content_type => 'application/x-yaml' }
    end
  end

  def successful
    @nodes = Node.successful.paginate(:page => params[:page])
    render :index
  end

  def failed
    @nodes = Node.failed.paginate(:page => params[:page])
    render :index
  end

  def unreported
    @nodes = Node.unreported.paginate(:page => params[:page])
    render :index
  end

  def no_longer_reporting
    @nodes = Node.no_longer_reporting.paginate(:page => params[:page])
    render :index
  end

  # TODO: routing currently can't handle nested resources due to node's id
  # requirements
  def reports
    @node = Node.find_by_name!(params[:id])
    @reports = @node.reports.paginate(:page => params[:page])
    render 'reports/index'
  end

  protected

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_name!(params[:id]))
  end

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.search(params[:q]).by_report_date.paginate(:page => params[:page]))
  end
end
