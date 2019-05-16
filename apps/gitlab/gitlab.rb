Dir["./models/*.rb"].each {|file| require file }

class Gitlab
  attr_accessor :obj_type, :obj_data

  def initialize(request_data={})
    @obj_type = request_data["object_kind"]
    @obj_data = request_data
  end

  def run!
    case self.obj_type
    when  "issue"
      issue = Issue.new(self.obj_data)
      issue.notify!
    else
    end
  end
end
