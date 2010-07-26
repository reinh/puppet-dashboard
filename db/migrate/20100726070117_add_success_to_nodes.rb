class AddSuccessToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :success, :boolean, :default => false
    add_column :nodes, :last_report_id, :integer

    Node.reset_column_information

    for node in Node.all
      report = node.find_last_report
      next unless report
      report.send(:update_node, true)
    end
  end

  def self.down
    remove_column :nodes, :success
  end
end
