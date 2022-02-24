require 'json_schemer'

class ResourceJsonValidator < ActiveModel::EachValidator

  JSONAPI_SCHEMA_FILE_PATH = File.join(Rails.root, 'public', 'api', 'jsonapi-schema-resource-json-resource.json')
  JSONAPI_SCHEMA_STUDY_DESIGN_FILE_PATH = File.join(Rails.root, 'public', 'api', 'jsonapi-schema-resource-json-addtional-study-design.json')

  def validate_each(record, attribute, value)
    #record=>#<StudyhubResource id: nil, resource_json: {"resource_titles"=>[{"title"=>"National Pandemi....
    # attribute=>:resource_json
    # value => {"resource_titles"=>[{"title"=>"National Pandemic Cohort Network ns, echocardiography, external laboratory data).

    Rails.logger.info('Validator:starting to check resource_json............')
    schema = JSONSchemer.schema(File.read(JSONAPI_SCHEMA_FILE_PATH))

    unless schema.valid?(value)
      schema.validate(value).each do |v|
        Rails.logger.info("- #{nice_error v}")
        record.errors.add(attribute.to_sym, (nice_error v))
      end
    end

    if record.is_studytype?
      Rails.logger.info('Validator:starting to check study design............')
      schema = JSONSchemer.schema(File.read(JSONAPI_SCHEMA_STUDY_DESIGN_FILE_PATH))

      unless schema.valid?(value)
        schema.validate(value).each do |v|
          Rails.logger.info("- #{nice_error v}")
          record.errors.add(attribute.to_sym, (nice_error v))
        end
      end
    end
  end


  def nice_error verr
    case verr['type']
    when 'required'
      "Path '#{verr["data_pointer"]}' is missing keys: #{verr["details"]["missing_keys"].join ', '}"
    when 'format'
      "Path '#{verr["data_pointer"]}' is not in required format (#{verr["schema"]["format"]})"
    when 'minLength'
      "Path '#{verr["data_pointer"]}' is not long enough (min #{verr["schema"]["minLength"]})"
    else
      "There is a problem with path '#{verr["data_pointer"]}'. Please check your input."
    end
  end

end