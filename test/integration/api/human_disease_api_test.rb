require 'test_helper'

class HumanDiseaseApiTest < ActionDispatch::IntegrationTest
  include ReadApiTestSuite

  def setup
    user_login
    @human_disease = Factory(:human_disease)
  end

  def skip_index_test?
    true
  end
end
