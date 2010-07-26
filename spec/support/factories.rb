# TODO figure out how to add these to exemplar.

class Report
  def self.generate_for(node, time, success)
    report = Report.new(:time => time, :success => success, :host => node, :node => node)
    report.stubs(:process_report => true, :report_contains_metrics => true)
    report.save!
    if node.reported_at.nil? or node.reported_at < time
      node.update_attribute(:reported_at, time)
    end
    return report
  end
end
