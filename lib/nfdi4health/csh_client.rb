require 'rest-client'

module Nfdi4Health

  class Client

    ENDPOINT = 'https://fea2cb92-c178-442f-a62d-856736138128.mock.pstmn.io'.freeze

    def initialize(endpoint = nil)
      endpoint ||= ENDPOINT
      @endpoint = RestClient::Resource.new(endpoint)
    end

    def publish_study(study)
      @endpoint['publish'].post(study, content_type: 'application/json;charset=UTF-8')
    end

  end
end
