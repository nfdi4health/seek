require 'json-schema'

class ResourceJsonValidator < ActiveModel::EachValidator

  JSONAPI_SCHEMA_FILE_PATH = File.join(Rails.root, 'public', 'api', 'jsonapi-schema-resource-json.json')

  def validate_each(record, attribute, value)
    #record=>#<StudyhubResource id: nil, resource_json: {"resource_titles"=>[{"title"=>"National Pandemi....
    # attribute=>:resource_json
    # value => {"resource_titles"=>[{"title"=>"National Pandemic Cohort Network ns, echocardiography, external laboratory data).

    Rails.logger.info('Validator:starting to check resource_json............')

    begin
      JSON::Validator.validate!(JSONAPI_SCHEMA_FILE_PATH, value, strict: true)
      # JSON::Validator.validate!(JSONAPI_SCHEMA_FILE_PATH, value)
    rescue JSON::Schema::ValidationError => e
      Rails.logger.info("+++++++++++++++++++++++++")
      Rails.logger.info("e:"+e.message)
      record.errors.add(:attribute, e.message)
    end
  end

end