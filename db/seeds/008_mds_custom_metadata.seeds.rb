# Initialisation of aliases for common sample attributes types, for easier use.
@mds_version = '2.1'

@int_type = SampleAttributeType.find_or_initialize_by(title: 'Integer')
@int_type.update(base_type: Seek::Samples::BaseType::INTEGER, placeholder: '1')

@bool_type = SampleAttributeType.find_or_initialize_by(title: 'Boolean')
@bool_type.update(base_type: Seek::Samples::BaseType::BOOLEAN)

@float_type = SampleAttributeType.find_or_initialize_by(title: 'Real number')
@float_type.update(base_type: Seek::Samples::BaseType::FLOAT, placeholder: '0.5')

@date_type = SampleAttributeType.find_or_initialize_by(title: 'Date')
@date_type.update(base_type: Seek::Samples::BaseType::DATE, placeholder: 'January 1, 2022')

@string_type = SampleAttributeType.find_or_initialize_by(title: 'String')
@string_type.update(base_type: Seek::Samples::BaseType::STRING)

@cv_type = SampleAttributeType.find_or_initialize_by(title: 'Controlled Vocabulary')
@cv_type.update(base_type: Seek::Samples::BaseType::CV)

@text_type = SampleAttributeType.find_or_initialize_by(title: 'Text')
@text_type.update(base_type: Seek::Samples::BaseType::TEXT, placeholder: '1')

@link_type = SampleAttributeType.find_or_initialize_by(title: 'Web link')
@link_type.update(base_type: Seek::Samples::BaseType::STRING, regexp: URI.regexp(%w(http https)).to_s, placeholder: 'http://www.example.com', resolution: '\\0')

# helper to create sample controlled vocab
def create_cv_attr_terms(array)
  attributes = []
  array.each do |type|
    attributes << { label: type }
  end
  attributes
end

def sanitize_label(s)
  s.downcase.gsub('(', '_').gsub(')', '_').gsub(' ', '_')
end

def create_cm_attr(namespace:, label:, required:, type:, cv: nil)
  CustomMetadataAttribute.where(title: "#{namespace}/#{sanitize_label(label)}").first_or_create!(
    label: label,
    required: required,
    sample_attribute_type: type,
    sample_controlled_vocab: cv
  )
end

disable_authorization_checks do
  @type_cv = SampleControlledVocab.where(key: "mds-#{@mds_version}/study-type").first_or_create!(
    title: 'Study Type',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        'Single group ', 'Parallel ', 'Crossover ', 'Factorial ', 'Sequential ', 'Other', 'Unknown', 'Case-control',
        'Nested case-control', 'Case-only', 'Case-crossover', 'Ecologic or community studies', 'Family-based',
        'Twin study', 'Cohort', 'Case-cohort', 'Birth cohort', 'Trend', 'Panel', 'Longitudinal', 'Cross-section',
        'Cross-section ad-hoc follow-up', 'Time series', 'Quality control', 'Registry',
      ]
    )
  )
end

disable_authorization_checks do
  @status_cv = SampleControlledVocab.where(key: "mds-#{@mds_version}/study-status").first_or_create!(
    title: 'Study Status',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        'At the planning stage',
        'Ongoing (I): Recruitment ongoing, but data collection not yet started',
        'Ongoing (II): Recruitment and data collection ongoing',
        'Ongoing (III): Recruitment completed, but data collection ongoing',
        'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing',
        'Suspended: Recruitment, data collection, or data quality management, halted, but potentially will resumed',
        'Terminated: Recruitment, data collection, data and quality management halted prematurely and will not resume',
        'Completed: Recruitment, data collection, and data quality management completed normally',
        'Other',
      ]
    )
  )
end

disable_authorization_checks do
  @groups_of_diseases_cv = SampleControlledVocab.where(key: "mds-#{@mds_version}/study-groups-of-diseases").first_or_create!(
    title: 'Study Groups of Diseases',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        'Certain infectious or parasitic diseases (01)',
        'Neoplasms (02)',
        'Diseases of the blood or blood-forming organs (03)',
        'Diseases of the immune system (04)',
        'Endocrine, nutritional or metabolic diseases (05)',
        'Mental, behavioural or neurodevelopmental disorders (06)',
        'Sleep-wake disorders (07)',
        'Diseases of the nervous system (08)',
        'Diseases of the visual system (09)',
        'Diseases of the ear or mastoid process (10)',
        'Diseases of the circulatory system (11)',
        'Diseases of the respiratory system (12)',
        'Diseases of the digestive system (13)',
        'Diseases of the skin (14)',
        'Diseases of the musculoskeletal system or connective tissue (15)',
        'Diseases of the genitourinary system (16)',
        'Conditions related to sexual health (17)',
        'Pregnancy, childbirth or the puerperium (18)',
        'Certain conditions originating in the perinatal period (19)',
        'Developmental anomalies (20)',
        'Symptoms, signs or clinical findings, not elsewhere classified (21)',
        'Injury, poisoning or certain other consequences of external causes (22)',
        'External causes of morbidity or mortality (23)',
        'Factors influencing health status or contact with health services (24)',
        'Other',
        'Unknown',
      ]
    )
  )
end

disable_authorization_checks do
  @data_sharing_plan_cv = SampleControlledVocab.where(key: "mds-#{@mds_version}/study-data-sharing-plan").first_or_create!(
    title: 'Study Data Sharing Plan',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        'Yes, there is a plan to make data available',
        'No, there is no plan to make data available',
        'Undecided, it is not yet known if data will be made available',
      ]
    )
  )
end

def create_generic_attributes(namespace)
  [
    create_cm_attr(namespace: namespace, label: 'Title (EN)', required: true, type: @string_type),
    create_cm_attr(namespace: namespace, label: 'Description (EN)', required: true, type: @text_type),
    create_cm_attr(namespace: namespace, label: 'Acronym (EN)', required: false, type: @string_type),
    create_cm_attr(namespace: namespace, label: 'Acronym (DE)', required: false, type: @string_type),
    create_cm_attr(namespace: namespace, label: 'Type', required: true, type: @cv_type, cv: @type_cv),
    create_cm_attr(namespace: namespace, label: 'Status', required: true, type: @cv_type, cv: @status_cv),
    create_cm_attr(namespace: namespace, label: 'Start Date', required: false, type: @date_type),
    create_cm_attr(namespace: namespace, label: 'End Date', required: false, type: @date_type),
    create_cm_attr(namespace: namespace, label: 'Web Page', required: false, type: @link_type),
    create_cm_attr(namespace: namespace, label: 'Groups of Diseases', required: true, type: @cv_type, cv: @groups_of_diseases_cv),
    create_cm_attr(namespace: namespace, label: 'Sample Size', required: false, type: @int_type),
    create_cm_attr(namespace: namespace, label: 'Number of Sites', required: false, type: @int_type),
    create_cm_attr(namespace: namespace, label: 'Data Sharing Plan', required: true, type: @cv_type, cv: @data_sharing_plan_cv),
  ]
  # Missing study_design.study_countries
  #                      study_groups_of_diseases_prevalent_outcomes
  #                      study_groups_of_diseases_incident_outcomes
end

disable_authorization_checks do
  ['Study', 'Investigation'].each do |isa_type|
    CustomMetadataType.where(title: "MDS #{@mds_version} Non-Interventional Study", supported_type: isa_type).first_or_create!(
      custom_metadata_attributes: create_generic_attributes("#{isa_type.downcase}.nis")
    )
    CustomMetadataType.where(title: "MDS #{@mds_version} Interventional Study", supported_type: isa_type).first_or_create!(
      custom_metadata_attributes: create_generic_attributes("#{isa_type.downcase}.is")
    )
  end
end

puts "Seeded MDS #{@mds_version}"
