require 'rest-client'

module Nfdi4Health

  class Client

    def initialize(endpoint)
      @endpoint = RestClient::Resource.new(endpoint)
    end

    def publish_study(study)
      @endpoint['publish'].post(study, content_type: 'application/json;charset=UTF-8')
    end

  end
end
