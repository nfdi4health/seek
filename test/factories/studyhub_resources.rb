require 'json'

max_studyhub_study_json_text = '{
  "ids": [
    {
      "date": "02.09.2021",
      "type": "DOI",
      "identifier": "10.1002/14651858.CD013825.pub2",
      "relation_type": "A is described by B",
      "resource_type_general": "Text"
    },
    {
      "date": "28.09.2020",
      "type": "DOI",
      "identifier": "10.1016/S2665-9913(20)30341-6",
      "relation_type": "A is described by B",
      "resource_type_general": "Journal article"
    }
  ],
  "roles": [
    {
      "role_email": "korinna.pilz@inflarx.de",
      "role_phone": "+49 (0)89 41418978",
      "role_name_type": "Personal",
      "role_affiliations": [
        {
          "role_affiliation_name": "InflaRx",
          "role_affiliation_address": "Fraunhoferstraße 22, 82152, Martinsried, Germany",
          "role_affiliation_web_page": "https://www.inflarx.de/",
          "role_affiliation_identifiers": [
            {
              "scheme": "ROR",
              "identifier": "00fm1n282"
            },
            {
              "scheme": "GRID",
              "identifier": "grid.476439.b"
            }
          ]
        }
      ],
      "role_name_personal": {
        "type": "Contact",
        "role_name_personal_title": "Dr.",
        "role_name_personal_given_name": "Korinna",
        "role_name_personal_family_name": "Pilz"
      }
    },
    {
      "role_email": "info@inflarx.de",
      "role_phone": "+49 (0)89 4141897800",
      "role_name_type": "Organisational",
      "role_affiliations": [
        {
          "role_affiliation_name": "InflaRx GmbH",
          "role_affiliation_address": "Fraunhoferstraße 22, 82152, Martinsried, Germany",
          "role_affiliation_web_page": "https://www.inflarx.de/",
          "role_affiliation_identifiers": [
            {
              "scheme": "ROR",
              "identifier": "00fm1n282"
            },
            {
              "scheme": "GRID",
              "identifier": "grid.476439.b"
            }
          ]
        }
      ],
      "role_name_organisational_group": {
        "type": "Sponsor (primary)",
        "role_name_organisational_group_name": "InflaRx GmbH"
      }
    },
    {
      "role_email": "a.p.vlaar@amsterdamumc.nl",
      "role_name_type": "Personal",
      "role_affiliations": [
        {
          "role_affiliation_name": "University of Amsterdam",
          "role_affiliation_address": "Spui 21, 1012, WX Amsterdam, The Netherlands",
          "role_affiliation_web_page": "https://www.uva.nl/en",
          "role_affiliation_identifiers": [
            {
              "scheme": "ROR",
              "identifier": "04dkp9463"
            },
            {
              "scheme": "GRID",
              "identifier": "grid.7177.6"
            }
          ]
        }
      ],
      "role_name_personal": {
        "type": "Principal investigator",
        "role_name_identifiers": [
          {
            "scheme": "ORCID",
            "identifier": "0000-0002-3453-7186"
          }
        ],
        "role_name_personal_title": "Other",
        "role_name_personal_given_name": "Alexander",
        "role_name_personal_family_name": "Vlaar"
      }
    }
  ],
  "provenance": {
    "data_source": "Manually collected"
  },
  "study_design": {
    "study_type": {
      "study_type_interventional": [
        "Parallel"
      ]
    },
    "study_region": "Brussels, Leuven, Yvoir, Campinas, Criciúma, Porto Alegre, São José, Grenoble, Nantes, Nice, Paris, Saint-Étienne, Suresnes, Aachen, Augsburg, Berlin, Dresden, Greifswald, Hannover, Jena, Chihuahua, Culiacán, Mérida, Nuevo León, Amsterdam, Eindhoven, Enschede, Maastricht, Callao, Lima, Barnaul, Moscow",
    "study_status": "Ongoing (II): Recruitment and data collection ongoing",
    "study_centers": "Multicentric",
    "study_subject": "Person",
    "study_end_date": "31.12.2021",
    "study_outcomes": [
      {
        "study_outcome_type": "Primary",
        "study_outcome_title": "Mortality",
        "study_outcome_time_frame": "Day 28",
        "study_outcome_description": "28-day all-cause mortality"
      },
      {
        "study_outcome_type": "Secondary",
        "study_outcome_title": "Treatment Emergent Adverse Events",
        "study_outcome_time_frame": "Day 1 to Day 60",
        "study_outcome_description": "Frequency, severity, and relatedness to study drug of serious and non-serious TEAEs"
      },
      {
        "study_outcome_type": "Secondary",
        "study_outcome_title": "Safety Parameters",
        "study_outcome_time_frame": "Day 15, Day 28",
        "study_outcome_description": "Proportion of patients with an improvement in the 8-point ordinal scale"
      }
    ],
    "study_sampling": {
      "study_sampling_method": "Unknown"
    },
    "study_countries": [
      "Belgium",
      "Brazil",
      "France",
      "Germany",
      "Mexico",
      "Netherlands",
      "Peru",
      "Russian Federation",
      "South Africa"
    ],
    "study_conditions": [
      {
        "study_conditions_label": "Severe COVID-19 Pneumonia",
        "study_conditions_classification": "Free text",
        "study_conditions_classification_code": ""
      }
    ],
    "study_hypothesis": "Information is not provided.",
    "study_population": "No additional information is provided.",
    "study_start_date": "31.03.2020",
    "study_arms_groups": [
      {
        "study_arm_group_type": "Experimental",
        "study_arm_group_label": "Arm A",
        "study_arm_group_description": "SOC + IFX-1"
      },
      {
        "study_arm_group_type": "Experimental",
        "study_arm_group_label": "Arm B",
        "study_arm_group_description": "SOC + Placebo"
      }
    ],
    "study_data_source": {
      "study_data_sources_general": [
        "Other"
      ],
      "study_data_source_description": "Data were collected from the hospital patient files. "
    },
    "study_interventions": [
      {
        "study_intervention_name": "SOC + IFX-1",
        "study_intervention_type": "Drug (including placebo)",
        "study_intervention_description": "No additional information is provided.",
        "study_intervention_arms_groups_label": [
          "Arm A"
        ]
      },
      {
        "study_intervention_name": "SOC + Placebo",
        "study_intervention_type": "Drug (including placebo)",
        "study_intervention_description": "No additional information is provided.",
        "study_intervention_arms_groups_label": [
          "Arm B"
        ]
      }
    ],
    "study_centers_number": 42,
    "study_design_comment": "No additional information is provided.",
    "study_primary_design": "Interventional",
    "study_primary_purpose": "Treatment",
    "study_age_max_examined": {
      "number": 69,
      "time_unit": "Years"
    },
    "study_age_min_examined": {
      "number": 51,
      "time_unit": "Years"
    },
    "study_data_sharing_plan": {
      "study_data_sharing_plan_generally": "No, there is no plan to make data available",
      "study_data_sharing_plan_description": "No additional information is provided."
    },
    "study_groups_of_diseases": {
      "study_groups_of_diseases_generally": [
        "Unknown"
      ]
    },
    "study_target_sample_size": 390,
    "study_eligibility_criteria": {
      "study_eligibility_age_min": {
        "number": 18,
        "time_unit": "Years"
      },
      "study_eligibility_genders": [
        "Male",
        "Female",
        "Diverse"
      ],
      "study_eligibility_exclusion_criteria": "- Known history of progressed COPD as evidenced by use of daily maintenance treatment with long-acting bronchodilators or inhaled/oral corticosteroids for > 2 months\r\n- Patient moribund or expected to die in next 24h according to the judgment of the investigator\r\n- Known severe congestive heart failure (New York Heart Association [NYHA] Class III- IV\r\n- Received organ or bone marrow transplantation in past 3 months\r\n- Known cardio-pulmonary mechanical resuscitation in past 14 days",
      "study_eligibility_inclusion_criteria": "- At least 18 years of age or older\r\n- Clinically evident or otherwise confirmed severe pneumonia\r\n- SARS-CoV-2 infection confirmation (tested positive in last 14 days before randomization with locally available test system)"
    },
    "study_obtained_sample_size": -1,
    "study_design_interventional": {
      "study_phase": "Phase-2-phase-3",
      "study_masking": {
        "study_masking_roles": [
          "Participant",
          "Investigator"
        ],
        "study_masking_general": true,
        "study_masking_description": "Phase II: Open label study (30 patients) Phase III: Double- blind; (360 patients)"
      },
      "study_allocation": "Randomized",
      "study_off_label_use": "No"
    },
    "study_status_when_intervention": "Intervention completed, follow-up ongoing",
    "study_ethics_committee_approval": "Unknown status of request approval",
    "study_status_enrolling_by_invitation": "Not applicable"
  },
  "ids_alternative": [
    {
      "type": "NCT (ClinicalTrials.gov)",
      "identifier": "NCT04333420"
    },
    {
      "type": "Other",
      "identifier": "IFX-1-P2.9"
    }
  ],
  "resource_titles": [
    {
      "text": "A Pragmatic Adaptive Randomized, Controlled Phase II/III Multicenter Study of IFX-1 in Patients With Severe COVID-19 Pneumonia",
      "language": "EN (English)"
    }
  ],
  "resource_acronyms": [
    {
      "text": "PANAMO",
      "language": "EN (English)"
    }
  ],
  "resource_keywords": [
    {
      "resource_keywords_label": "COVID-19 related severe pneumonia",
      "resource_keywords_label_code": ""
    },
    {
      "resource_keywords_label": "COVID-19",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D000086382"
    },
    {
      "resource_keywords_label": "Pneumonia",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D011014"
    },
    {
      "resource_keywords_label": "Respiratory Tract Infections",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D012141"
    },
    {
      "resource_keywords_label": "Infections",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D007239"
    },
    {
      "resource_keywords_label": "Pneumonia, Viral",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D011024"
    },
    {
      "resource_keywords_label": "Virus Diseases",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D014777"
    },
    {
      "resource_keywords_label": "Coronavirus Infections",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D018352"
    },
    {
      "resource_keywords_label": "Coronaviridae Infections",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D003333"
    },
    {
      "resource_keywords_label": "Nidovirales Infections",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D030341"
    },
    {
      "resource_keywords_label": "RNA Virus Infections",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D012327"
    },
    {
      "resource_keywords_label": "Lung Diseases",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D008171"
    },
    {
      "resource_keywords_label": "Respiratory Tract Diseases",
      "resource_keywords_label_code": "http://id.nlm.nih.gov/mesh/D012140"
    }
  ],
  "resource_web_page": "https://www.inflarx.de/Home/Investors/Press-Releases/03-2020-InflaRx-Doses-First-Patient-in-Multicenter-Randomized-Clinical-Trial-in-Severe-Progressed-COVID-19-Pneumonia-in-Europe-upon-Receipt-of-Initial-Positive-Human-Data-with-InflaRx-s-anti-C5a-Technology.html",
  "resource_languages": [
    "EN (English)"
  ],
  "resource_classification": {
    "resource_type": "Study"
  },
  "resource_description_english": {
    "text": "This is a pragmatic, adaptive, randomized, multicenter phase II/III study evaluating IFX-1 for the treatment of COVID-19 related severe pneumonia. The study consists of two parts: Phase II, an open-label, randomized, 2-arm phase evaluating best supportive care (BSC) + IFX-1 (Arm A) and BSC alone (Arm B); and Phase III, a double-blind, placebo-controlled, randomized phase comparing standard of care (SOC) + IFX-1 (Arm A) versus SOC + placebo-to-match (Arm B).",
    "language": "EN (English)"
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
