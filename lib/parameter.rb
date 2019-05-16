module Parameter
  def self.included(base)
    base.class_eval do
      attr_accessor :request_params
      
      def request_params
        @request_params ||= JSON.parse(request.body.read)
      end
    end
  end
  
  #def request_params
  #  @request_params ||= JSON.parse(request.body.read)
  #end
end
