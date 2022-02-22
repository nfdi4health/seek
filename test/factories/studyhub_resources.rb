require 'json'

max_studyhub_study_json_text = '{
        "resource_type": "study",
        "resource_type_general": "Other",
        "resource_titles": [
          {
            "title": "National Pandemic Cohort Network - High-resolution Platform (HAP) Analysis of the Pathophysiology and Pathology of Coronavirus Disease 2019 (COVID-19), Including Chronic Morbidity",
            "title_language": "EN (English)"
          }
        ],
        "resource_acronyms": [
          {
            "acronym": "Not existing",
            "acronym_language": "EN (English)"
          }
        ],
        "resource_descriptions": [
          {
            "description": "This is a description",
            "description_language": "EN (English)"
          },
          {
            "description": "This is a description1",
            "description_language": "EN (English)"
          }
        ],
        "resource_keywords": [
          {
            "resource_keywords_label": "COVID-191",
            "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D000086382"
          },
          {
            "resource_keywords_label": "COVID-19",
            "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D000086382"
          }
        ],
        "resource_language": ["EN (English)", "DE (German)"],
        "resource_web_page": "https://napkon.de/1",
        "resource_version": "",
        "resource_format": "",
        "resource_use_rights_label": "CC0 1.0 (Creative Commons Zero v1.0 Universal)",
        "resource_use_rights_description": "No additional information is provided.",
        "resource_use_rights_authors_confirmation_1": true,
        "resource_use_rights_authors_confirmation_2": true,
        "resource_use_rights_authors_confirmation_3": true,
        "resource_use_rights_support_by_licencing": true,
        "roles": [
          {
            "role_type": "Principal investigator",
            "role_name_type": "Personal",
            "role_name_personal_given_name": "Martin",
            "role_name_personal_family_name": "Witzenrath",
            "role_name_personal_title": "Prof. Dr.",
            "role_name_identifiers": [

            ],
            "role_email": "martin.witzenrath@charite.de",
            "role_phone": "+49 (0)30 450553892",
            "role_affiliation_name": "Charité University Hospital",
            "role_affiliation_address": "Berlin, Germany, 13353",
            "role_affiliation_web_page": "https://www.charite.de/en/",
            "role_affiliation_identifiers": [
              {
                "role_affiliation_identifier": "001w7jn25",
                "role_affiliation_identifier_scheme": "ROR"
              }
            ]
          },
          {
            "role_type": "Funder(public)",
            "role_email": "",
            "role_phone": "",
            "role_name_type": "Organisational",
            "role_affiliation_name": "",
            "role_affiliation_address": "",
            "role_name_organisational": "HITS",
            "role_affiliation_web_page": "",
            "role_affiliation_identifiers": []
          }
        ],
        "ids": [
          {
            "id_id": "https://osf.io/d6wgr/",
            "id_type": "URL",
            "id_date": "18.09.2022",
            "id_resource_type_general": "Preprint",
            "id_relation_type": "is described by"
          }
        ],
        "study_design": {
          "study_primary_design": "Non-interventional",
          "study_type": "Cohort",
          "study_type_description": "No additional information is provided.",
          "study_conditions": [
            {
              "study_conditions": "COVID-19",
              "study_conditions_classification": "MeSH",
              "study_conditions_classification_code": "http://id.nlm.nih.gov/mesh/D000086382"
            }
          ],
          "study_ethics_commitee_approval": "Unknown",
          "study_status": "Ongoing (II): Recruitment and data collection ongoing",
          "study_status_enrolling_by_invitation": "",
          "study_status_when_intervention": "",
          "study_status_halted_stage": "",
          "study_status_halted_reason": "",
          "study_recruitment_status_register": "",
          "study_start_date": "06.11.2020",
          "study_end_date": "01.01.2025",
          "study_country": ["Germany","China"
          ],
          "study_region": "Freiburg, Heidelberg, Munich, Frankfurt, Giessen, Hannover, Cologne, Kiel, Lübeck, Jena, Berlin",
          "study_centers": "",
          "study_centers_number": 3,
          "study_subject": "Person",
          "study_sampling": "",
          "study_data_source": ["Blood"],
          "study_data_source_description": "Additional information about questionnaires and other instruments and data sources used in the study can be found in the description of the outcomes.",
          "study_eligibility_age_min": 18,
          "study_eligibility_age_min_description": "No additional information is provided.",
          "study_eligibility_age_max": -1,
          "study_eligibility_age_max_description": "No additional information is provided.",
          "study_eligibility_gender": [],
          "study_eligibility_inclusion_criteria": "- Age ≥ 18 years\r\n- Willingness to participate in the study (consent to participate by patient or appropriate legal representative) or inclusion via deferred consent\r\n- Hospitalization at time of enrollment\r\n- Positive evidence for SARS-CoV-2 infection with PCR (polymerase chain reaction) or initial positive rapid diagnostic test in conjunction with typical clinical symptoms, confirmed by a later positive PCR test.",
          "study_eligibility_exclusion_criteria": "- Refusal to participate by patient, or appropriate legal representative\r\n- Any condition that prohibits supplemental blood-sampling beyond routine blood drawing",
          "study_population": "COVID-19 patients, hospitalised at any of the participating hospitals (see study sites) over the age of 18 years, who are willing and deemed able to participate in the study.",
          "study_target_sample_size": 1,
          "study_obtained_sample_size": -13,
          "study_age_min_examined": null,
          "study_age_min_examined_description": "No additional information is provided.",
          "study_age_max_examined": null,
          "study_age_max_examined_description": "No additional information is provided.",
          "study_hypothesis": "Information is not provided.",
          "study_outcomes": [
            {
              "study_outcome_type": "Primary",
              "study_outcome_title": "Changes in Patient-reported Quality of life recorded with the help of the European Quality of Life 5 Dimensions 5 Level Version (Eq5d5l) questionnaire",
              "study_outcome_description": "Health related quality of life after hospital discharge will be assessed with the questionnaire European Quality of Life 5 Dimensions 5 Level Version (Eq5d5l)",
              "study_outcome_time_frame": "Day 1 of enrollment in the study, immediately before discharge, 3, 12, 24 and 36 months after symptom onset."
            }
          ],
          "study_design_comment": "Study type: Non-interventional/Observational [Patient Registry]",
          "study_data_sharing_plan_generally": "No, there is no plan to make data available.",
          "study_data_sharing_plan_description": "Given a concrete inquiry and prior consent by the study participants in question, IPD (individual participant data) can be made available on a case by case basis.",
          "study_data_sharing_plan_supporting_information": [],
          "study_data_sharing_plan_time_frame": "Information is not provided.",
          "study_data_sharing_plan_access_criteria": "Information is not provided.",
          "study_data_sharing_plan_url": "",
          "study_time_perspective": ["1149"],
          "study_target_follow-up_duration": null,
          "study_biospecimen_retention": [],
          "study_biospecomen_description": "Saliva, Urin, Oropharyngeal / Nasopharyngeal swab / Bronchoalveolar lavage (BAL) / Endotracheal aspirate (ENTA), whole blood",
          "study_primary_purpose": "Treatment",
          "study_phase": "",
          "study_masking": null,
          "study_masking_roles": [],
          "study_masking_description": "",
          "study_allocation": "",
          "study_off_label_use": "",
          "interventional_study_design_arms": [
            {
              "study_arm_group_label": "Name of the arm",
              "study_arm_group_type": "Active comparator",
              "study_arm_group_description": "Additional information about the arm"
            }
          ],
          "interventional_study_design_interventions": [
            {
              "study_intervention_name": "Name of the intervention",
              "study_intervention_type": "Biological/Vaccine",
              "study_intervention_description": "Additional information about the intervention",
              "study_intervention_arm_group_label": "Associated arm"
            }
          ]
        },
        "provenance": {
          "data_source": "ICTRP"
        }

}'



max_studyhub_study_json = JSON.parse(max_studyhub_study_json_text)



## Studyhub Resource Type
Factory.define(:studyhub_resource_type_study, class: StudyhubResourceType ) do |f|
  f.title 'Study'
  f.key 'study'
end

Factory.define(:studyhub_resource_type_dataset, class: StudyhubResourceType ) do |f|
  f.title 'Dataset'
  f.key 'dataset'
end


## StudyhubResource

Factory.define(:studyhub_resource, class: StudyhubResource ) do |f|
  f.studyhub_resource_type factory: :studyhub_resource_type_study
  f.with_project_contributor
  f.resource_json max_studyhub_study_json
end
