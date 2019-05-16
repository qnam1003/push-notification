class Issue
  attr_accessor :user, :object_attributes, :project, :repository, :assignees, :assignee, :labels, :changes
  attr_accessor :slack, :chatwork
  
  def initialize(attr)
    @user = attr["user"]
    @project = attr["project"]
    @object_attributes = attr["object_attributes"]
    @repository = attr["repository"]
    @assignees = attr["assignees"]
    @assignee = attr["assignee"]
    @labels = attr["labels"]
    @changes = attr["changes"]
  end

  def changes_current
    return if self.changes.blank?
    return if self.changes["labels"].blank?
    self.changes["labels"]["current"]
  end

  def changes_previous
    return if self.changes.blank?
    return if self.changes["labels"].blank?
    self.changes["labels"]["previous"]
  end
  
  def notify!
    return if self.assignees.blank?
    to = self.assignees.map{|x| "@#{x["username"]}"}.join(", ")
    from = "#{self.user["username"]}"
    label_titles = self.labels.map{|x| "`#{x["title"]}`"}.join(" ")
    text = <<-EOF
      `To:` #{to}
      `Url:` #{self.object_attributes["url"]}
      ```
      From: #{from}
      Issue: #{self.object_attributes["title"]}
      Content: #{from} changed issue labels to #{label_titles}
      ```
    EOF
    #slack.chat_postMessage(channel: '#website', text: text, as_user: true)
    chatwork.sendMessage("gitlab_issues_exchange_package", text)
  end

  def slack
    @slack ||= Slack::Web::Client.new
  end

  def chatwork
    @chatwork ||= Chatwork.new
  end
end
