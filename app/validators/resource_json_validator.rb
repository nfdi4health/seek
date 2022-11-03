require 'json_schemer'

class ResourceJsonValidator < ActiveModel::EachValidator

  JSONAPI_MDS_NON_STUDY_FILE_PATH = File.join(Rails.root, 'public', 'api', 'mds_non_study_schema.json')
  JSONAPI_MDS_STUDY_NON_INTERVENTIONAL_PATH = File.join(Rails.root, 'public', 'api', 'mds_json_schema_study_non_interventional.json')
  JSONAPI_MDS_STUDY_INTERVENTIONAL_PATH = File.join(Rails.root, 'public', 'api', 'mds_json_schema_study_interventional.json')



  def validate_each(record, attribute, value)
    #record=>#<StudyhubResource id: nil, resource_json: {"resource_titles"=>[{"title"=>"National Pandemi....
    # attribute=>:resource_json
    # value => {"resource_titles"=>[{"title"=>"National Pandemic Cohort Network ns, echocardiography, external laboratory data).

    Rails.logger.info('Validator:starting to check resource_json............')

    if record.is_studytype?
      Rails.logger.info('Validator:starting to check study ............')
      Rails.logger.info('Study Type: ............')
      if record.resource_json['study_design']['study_primary_design'].blank?
        record.errors['study_primary_design'] << 'please assign an value.'
        return
      end

      path = record.is_non_interventional_study?? JSONAPI_MDS_STUDY_NON_INTERVENTIONAL_PATH : JSONAPI_MDS_STUDY_INTERVENTIONAL_PATH
      schema = JSONSchemer.schema(File.read(path))

    else
      Rails.logger.info('Validator:starting to check non study ............')
      schema = JSONSchemer.schema(File.read(JSONAPI_MDS_NON_STUDY_FILE_PATH))
    end


    unless schema.valid?(value)
      schema.validate(value).each do |v|
        Rails.logger.info("- #{nice_error v}")
        record.errors.add(attribute.to_sym, (nice_error v))
      end
    end
  end

  private

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