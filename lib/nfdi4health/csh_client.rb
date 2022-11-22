require 'rest-client'

module Nfdi4Health

  class Client

    def initialize(endpoint)
      @endpoint = RestClient::Resource.new(endpoint)
    end

    def publish_study(study)
      mds_study = generate_mds_study(study)
      @endpoint['publish'].post(mds_study.to_json, content_type: 'application/json;charset=UTF-8')
    end

    private

    def get_cm_attr(res, title)
      res.custom_metadata.get_attribute_value(title)
    end

    def generate_mds_study(study)
      {
        data: {
          provenance: {
            data_source: 'Manually collected',
          },
          resource_id: generate_id(study),
          resource_classification: {
            resource_type: 'Study',
          },
          resource_description_english: {
            text: get_cm_attr(study, "Study Description (EN)"),
            language: 'EN (English)',
          },
          resource_descriptions_non_english: [
            {
              text: study.description,
              language: 'DE (GERMAN)',
            },
          ],
          resource_titles: [
            {
              text: get_cm_attr(study, "Study Title (EN)"),
              language: 'EN (English)',
            },
            {
              text: study.title,
              language: 'DE (German)',
            },
          ],
          roles: generate_roles(study),
          study_design: {
            "study_countries": [
              'Germany'
            ],
            "study_data_sharing_plan": {
              "study_data_sharing_plan_generally": get_cm_attr(study, "Study Data Sharing Plan"),
            },
            "study_design_non_interventional": {},
            "study_groups_of_diseases": {
              "study_groups_of_diseases_generally": [get_cm_attr(study, "Study Groups of Diseases")],
              "study_groups_of_diseases_prevalent_outcomes": '',
              "study_groups_of_diseases_incident_outcomes": ''
            },
            "study_primary_design": 'Non-interventional',
            "study_status": get_cm_attr(study, "Study Status"),
            "study_subject": 'Person',
            "study_type": [get_cm_attr(study, "Study Type")]
          }
        }
      }
    end

    def generate_roles(study)
      roles = study.creators.map do |creator|
        {
          "role_email": creator.email,
          "role_name_type": 'Personal',
          "role_name_personal": {
            "role_name_personal_family_name": creator.last_name,
            "role_name_personal_given_name": creator.first_name,
            "role_name_personal_title": 'Other',
            "type": 'Creator/Author'
          }
        }
      end
      roles.append(
        {
          "role_email": study.contributor.email,
          "role_name_type": 'Personal',
          "role_name_personal": {
            "role_name_personal_family_name": study.contributor.last_name,
            "role_name_personal_given_name": study.contributor.first_name,
            "role_name_personal_title": 'Other',
            "type": 'Data manager'
          }
        }
      )
    end

    def generate_id(study)
      study.id
    end
  end
end
