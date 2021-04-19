require 'json'

max_studyhub_study_json_text = '{
  "resource_type": "study",
  "resource_type_general": "Other",
  "resource_language": "DE",
  "resource_web_page": "https://nako.de/",
  "resource_web_studyhub": "http://covid19.studyhub.nfdi4health.de/resource/10011",
  "resource_web_seek": "https://seek.studyhub.nfdi4health.de/documents/1",
  "resource_web_mica": "https://studycataloguebrowser.ship-med.uni-greifswald.de/study/nako-1",
  "resource_use_rights": "DE",
  "resource_source": "manually collected",
  "study": {
    "study_primary_design": "Non-interventional",
    "study_type": null,
    "study_analysis_unit": "Individual",
    "study_status": "Recruiting",
    "study_eligibility": "German residents in the age range of 20u201369 years",
    "study_sampling": null,
    "study_country": "Germany",
    "study_region": null,
    "study_conditions": "Investigation of causes underlying major chronic diseases, i.e..",
    "study_population": "General population",
    "study_target_sample_size": 200000,
    "study_obtained_sample_size": null,
    "study_age_min": 20,
    "study_age_max": 69,
    "study_start_date": "2014-10-01",
    "study_end_date": null,
    "study_design_comment": null,
    "study_datasource": "Blood; Urine; Questionnaires; Other",
    "study_hypothesis": null,
    "study_interventions": null,
    "study_primary_outcomes": null,
    "study_secondary_outcomes": null,
    "study_phase": null
  },
  "acronyms": [
    {
      "acronym_type": "Original",
      "acronym": "NAKO"
    }
  ],
  "alternativeIds": [
    {
      "id_id": "ISRCTN33578935",
      "id_type": "WHO",
      "relation_type": null
    }
  ],
  "contacts": [
    {
      "role_type": "Contact person",
      "role_name": "Lisa Kofink",
      "role_email": "lisa.kofink@nako.de",
      "role_phone": "+49 (0)622 1426200",
      "role_address": "",
      "role_specific_type": null,
      "role_specific_number": null,
      "role_web_page": ""
    }
  ],
  "descriptions": [
    {
      "description_text": "The German National Cohort (GNC) has been inviting men and women aged between 20 and 69 to 18 study centers throughout Germany since 2014. The participants are medically examined and questioned about their living conditions. The GNCu2019s aim is to investigate the causes of chronic diseases, such as cancer, diabetes, cardiovascular diseases, rheumatism, infectious diseases, and dementia in order to improve prevention, early diagnoses and treatment of these very widely spread diseases.",
      "description_type": "offical",
      "description_language": "EN"
    },
    {
      "description_text": "Die NAKO Gesundheitsstudie ist die bundesweite Gesundheitsstudie mit Ziel, die Entstehung von Krankheiten wie Krebs, Diabetes, Herzinfarkt und anderen besser zu verstehen, um Vorbeugung, Fru00fcherkennung und Behandlung in Deutschland zu verbessern. Warum wird der eine krank, der andere aber bleibt gesund? Das ist die zentrale Frage, die die NAKO beantworten mu00f6chte.",
      "description_type": "created",
      "description_language": "DE"
    }
  ],
  "titles": [
    {
      "title_type": "Original",
      "title": "Max studyhub study",
      "title_language": "DE"
    }
  ]
}'


min_studyhub_study_json_text = '{
  "resource_type": "study",
  "study": {
  },
  "descriptions": [
    {
      "description_text": "The German National Cohort (GNC) has been inviting men and women aged between 20 and 69 to 18 study centers throughout Germany since 2014. The participants are medically examined and questioned about their living conditions. The GNCu2019s aim is to investigate the causes of chronic diseases, such as cancer, diabetes, cardiovascular diseases, rheumatism, infectious diseases, and dementia in order to improve prevention, early diagnoses and treatment of these very widely spread diseases.",
      "description_type": "offical",
      "description_language": "EN"
    }
  ],
  "titles": [
    {
      "title_type": "Original",
      "title": "Min studyhub study",
      "title_language": "DE"
    }
  ]
}'



min_studyhub_study_json = JSON.parse(min_studyhub_study_json_text)
max_studyhub_study_json = JSON.parse(max_studyhub_study_json_text)

# StudyhubResource
Factory.define(:studyhub_study, class: StudyhubResource) do |f|
  f.sequence(:id) { |n| n }
  f.resource_type 'study'
end

Factory.define(:min_studyhub_study, class: StudyhubResource) do |f|
  f.resource_type 'study'
  f.resource_json min_studyhub_study_json
  f.nfdi_person_in_charge nil
  f.contact_stage '3'
  f.data_source nil
  f.comment nil
  f.exclusion_mica_reason nil
  f.exclusion_seek_reason nil
  f.exclusion_studyhub_reason nil
  f.inclusion_studyhub 1
  f.inclusion_seek 1
  f.inclusion_mica 1
end

Factory.define(:max_studyhub_study, class: StudyhubResource) do |f|
  f.resource_type 'study'
  f.resource_json max_studyhub_study_json
  f.nfdi_person_in_charge nil
  f.contact_stage '9'
  f.data_source 'RatSWD'
  f.comment nil
  f.exclusion_mica_reason 'Not applicable'
  f.exclusion_seek_reason nil
  f.exclusion_studyhub_reason nil
  f.inclusion_studyhub 1
  f.inclusion_seek 1
  f.inclusion_mica 1
end


Factory.define(:studyhub_assay, class: StudyhubResource) do |f|
  f.sequence(:id) { |n| n }
  f.resource_type 'assay'
end