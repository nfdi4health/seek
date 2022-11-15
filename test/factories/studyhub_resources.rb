require 'json'

max_studyhub_study_json_text = '{
                "ids": [
          {
            "date": "",
            "type": "DOI",
            "identifier": "10.4232/cils4eu-de.6655.5.0.0",
            "relation_type": "A is supplement to B",
            "resource_type_general": "Dataset"
          },
          {
            "date": "",
            "type": "DOI",
            "identifier": "10.31235/osf.io/azsb3",
            "relation_type": "A is supplement to B",
            "resource_type_general": "Preprint"
          },
          {
            "date": "",
            "type": "DOI",
            "identifier": "10.1080/14616696.2020.1825766",
            "relation_type": "A is supplement to B",
            "resource_type_general": "Journal article"
          }
        ],
        "roles": [
          {
            "role_email": "",
            "role_phone": "",
            "role_name_type": "Organisational",
            "role_affiliations": [
              {
                "role_affiliation_name": "Mannheim Centre for European Social Research (MZES)",
                "role_affiliation_address": "68159, Mannheim, Germany",
                "role_affiliation_web_page": "https://www.mzes.uni-mannheim.de/d7/en",
                "role_affiliation_identifiers": [
                  {
                    "scheme": "ROR",
                    "identifier": ""
                  }
                ]
              }
            ],
            "role_name_organisational_group": {
              "type": "Creator/Author",
              "role_name_organisational_group_name": "CILS4EU-DE",
              "role_name_organisational_group_type_funding_id": ""
            }
          },
          {
            "role_email": "joerg.dollmann@mzes.uni-mannheim.de",
            "role_phone": "+49(0)6211812851",
            "role_name_type": "Personal",
            "role_affiliations": [
              {
                "role_affiliation_name": "Mannheim Centre for European Social Research (MZES)",
                "role_affiliation_address": "68159, Mannheim, Germany",
                "role_affiliation_web_page": "",
                "role_affiliation_identifiers": [
                  {
                    "scheme": "ROR",
                    "identifier": "05bv91d86"
                  }
                ]
              }
            ],
            "role_name_personal": {
              "type": "Contact",
              "role_name_identifiers": [],
              "role_name_personal_title": "Dr.",
              "role_name_personal_given_name": "Jörg",
              "role_name_personal_family_name": "Dollmann"
            }
          }
        ],
				"provenance":{
					"data_source":"Manually collected",
					"resource_version":"",
					"verification_date":"",
					"verification_date_user":"",
					"last_update_posted_date":"",
					"last_update_posted_user":"",
					"last_update_submitted_date":"",
					"last_update_submitted_user":"",
					"resource_first_posted_date":"",
					"resource_first_posted_user":"",
					"resource_first_submitted_date":"",
					"resource_first_submitted_user":""
				},
				"study_design":{
					"study_type":[
						"Parallel"
					],
					"study_region":"",
					"study_status":"Ongoing (II): Recruitment and data collection ongoing",
					"study_centers":"Multicentric",
					"study_subject":"Person",
					"study_end_date":"31.12.2021",
					"study_outcomes":[
						{
							"study_outcome_type":"Primary",
							"study_outcome_title":"Interest in digital interventions (attitudes, behavioral intentions, behavioral experiences)",
							"study_outcome_time_frame":"T1 (prior/beginning of rehab/clinic stay);\r\nT2 (end of rehab/clinic stay approx. 5 weeks after T1)",
							"study_outcome_description":"Quantitative online questionnaire - Survey using UniPark"
						}
					],
					"study_sampling":{
						"study_sampling_method":"Unknown"
					},
					"study_countries":[
						"Germany"
					],
					"study_conditions":[
						{
							"study_conditions_label":"Psychosomatic Disorder; Psychological Distress; Psychological Stress; Psychological Disease; Psychological Disorder; Psychological Impairment; Psychological Disability; Psychological Adjustment; Psychological Adaptation; Communication; Health Care Seeking Behavior; Anxiety; Behavior, Health; Health Risk Behaviors; Healthy Lifestyle",
							"study_conditions_classification":"Other vocabulary",
							"study_conditions_classification_code":""
						}
					],
					"study_hypothesis":"",
					"study_population":"",
					"study_start_date":"01.07.2020",
					"study_arms_groups":[
						{
							"study_arm_group_type":"Experimental",
							"study_arm_group_label":"Partial digital group: depression",
							"study_arm_group_description":""
						}
					],
					"study_data_source":{
						"study_data_sources_omics":[],
						"study_data_sources_general":[],
						"study_data_sources_imaging":[],
						"study_data_source_description":"",
						"study_data_sources_biosamples":[]
					},
					"study_interventions":[
						{
							"study_intervention_name":"Training session adressing information and health literacy",
							"study_intervention_type":"Behavioral (e.g., psychotherapy, lifestyle counseling)",
							"study_intervention_description":"",
							"study_intervention_arms_groups_label":"Partial digital group: depression"
						}
					],
					"study_centers_number":null,
					"study_design_comment":"",
					"study_primary_design":"Interventional",
					"study_primary_purpose":"Health services research",
					"study_age_max_examined":{
						"number":33,
						"time_unit":""
					},
					"study_age_min_examined":{
						"number":22,
						"time_unit":""
					},
					"study_data_sharing_plan":{
						"study_data_sharing_plan_url":"",
						"study_data_sharing_plan_generally":"Yes, there is a plan to make data available",
						"study_data_sharing_plan_datashield":"",
						"study_data_sharing_plan_time_frame":"",
						"study_data_sharing_plan_description":"Individual participant data (IPD) will not be published. Other researchers are welcome to get in contact with the PI to get access to anonymous data.",
						"study_data_sharing_plan_access_criteria":"",
						"study_data_sharing_plan_supporting_information":[]
					},
					"study_groups_of_diseases":{
						"study_groups_of_diseases_generally":["Neoplasms (02)"],
						"study_groups_of_diseases_incident_outcomes":"",
						"study_groups_of_diseases_prevalent_outcomes":""
					},
					"study_target_sample_size":2000,
					"study_eligibility_criteria":{
						"study_eligibility_age_max":{
							"number":-1,
							"time_unit":""
						},
						"study_eligibility_age_min":{
							"number":18,
							"time_unit":""
						},
						"study_eligibility_genders":[
							"Male",
							"Female",
							"Diverse"
						],
						"study_eligibility_exclusion_criteria":"1) Inability to read and write; 2) Severe dementia; 3) Unwillingness to participate in the study and to sign consent form",
						"study_eligibility_inclusion_criteria":"1) Patients before the start of the treatment; 2) Selected by the clinic; 3) Invited to participate in the study"
					},
					"study_obtained_sample_size":null,
					"study_design_interventional":{
						"study_phase":"",
						"study_masking":{
							"study_masking_general":false
						},
						"study_allocation":"Randomized",
						"study_off_label_use":"Not applicable"
					},
					"study_status_when_intervention":"",
					"study_ethics_committee_approval":"Unknown status of request approval",
					"study_recruitment_status_register":"Recruiting",
					"study_status_enrolling_by_invitation":"No"
				},
				"ids_alternative":[
					{
						"type":"NCT (ClinicalTrials.gov)",
						"identifier":"NCT04453475"
					}
				],
				"ids_nfdi4health":[],
				"resource_titles":[
					{
						"text":"Therapies to Achieve Treatment Goals While Being Exposed to Hygiene and Distance Rules: Feasibility and Benefits of Digital Services During the COVID19 Pandemic (Anhand-COVID19)",
						"language":"EN (English)"
					}
				],
				"resource_acronyms":[
					{
						"text":"Anhand-COV19",
						"language":"EN (English)"
					}
				],
				"resource_keywords":[
					{
						"resource_keywords_label":"",
						"resource_keywords_label_code":""
					}
				],
				"resource_web_page":"",
				"resource_languages":[],
				"resource_classification":{
					"resource_type":"Study"
				},
				"resource_description_english":{
  					"text":"As a result of the pandemic, hygiene and distancing rules must be followed in Health care/ rehabilitation clinics to ensure the safety of patients and staff. This has led to extensive changes in the therapy processes, including a reduction in group sizes and maintaining distances within the groups, resulting in a reduction in the range of therapies available to individuals, since the number of employees remains unchanged and cannot be increased at will and in the short term due to the lack of qualified staff. In order for the treatment/rehabilitation goals to be achieved nonetheless, new forms of implementation of therapy programs must be developed in addition to organizational adjustments. Digitalization can be a significant support in this respect. The majority of patients in psychosomatic rehabilitation possess smartphones, meaning that the necessary infrastructure for the utilization of digital offers is available and can be used to the greatest possible extent. The use of digital measures within the therapeutic services supports the independence of the patients, as they can use the digital offers independently and flexibly in their own time.\r\n\r\nHow should Health care/rehabilitation services be designed in light of the SARS-CoV-2 pandemic and which services have the potential to buffer future crises: What general recommendations can be derived for the design of such services for routine care? What are support measures to encourage social participation and return to work?",
					"language":"EN (English)"
				},
				"resource_descriptions_non_english":[
				]
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
