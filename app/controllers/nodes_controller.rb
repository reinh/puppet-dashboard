class NodesController < InheritedResources::Base
  belongs_to :node_class, :optional => true
  belongs_to :node_group, :optional => true
  respond_to :html, :yaml, :json

  layout lambda {|c| c.request.xhr? ? false : 'application' }

  def index
    scoped_index
  end

  def successful
    scoped_index :successful
  end

  def failed
    scoped_index :failed
  end

  def unreported
    scoped_index :unreported
  end

  def no_longer_reporting
    scoped_index :no_longer_reporting
  end

  # FIXME: If this exists for anyone other than Teyo, that is a bug.
  def run
    @node = Node.find_by_name!(params[:id])
    hostname = @node.name
    system "/usr/sbin/puppetrun --host '#{hostname}' --ssldir /var/lib/puppet/ssl"

    if $?.success?
      flash[:success] = "Puppet run triggered successfully for #{hostname}"
    else
      flash[:failure] = "Puppet run failed for #{hostname}"
    end

    redirect_to @node
  end

  # TODO: routing currently can't handle nested resources due to node's id
  # requirements
  def reports
    @node = Node.find_by_name!(params[:id])
    @reports = @node.reports
    respond_to do |format|
      format.html { @reports = @reports.paginate(:page => params[:page]); render 'reports/index' }
      format.yaml { render :text => @reports.to_yaml, :content_type => 'application/x-yaml' }
      format.json { render :json => @reports.to_json }
    end
  end

  protected

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_name!(params[:id]))
  end

  # Render the index using the +scope_name+ (e.g. :successful for Node.successful).
  def scoped_index(scope_name=nil)
    set_collection_ivar(end_of_association_chain.search(params[:q]).by_report_date)
    set_collection_ivar(end_of_association_chain.send(scope_name)) if scope_name
    index! do |format|
      format.html { paginate_collection!; render :index }
      format.yaml { render :text => collection.to_yaml, :content_type => 'application/x-yaml' }
      format.json { render :json => collection.to_json }
    end
  end
end
