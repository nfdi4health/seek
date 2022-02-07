puts 'Seeded Studyhub Resource Types'
ActiveRecord::FixtureSet.create_fixtures(File.join(Rails.root, 'config/default_data'), 'studyhub_resource_types')
puts 'Seeded NFDI4Health Studyhub Resource Metadata'


configpath = File.join(Rails.root, 'config/default_data', 'studyhub_resource_attribute_descriptions.yml')
attribute_descriptions = YAML::load_file(configpath)

configpath = File.join(Rails.root, 'config/default_data', 'studyhub_resource_attribute_heading.yml')
attribute_headings = YAML::load_file(configpath)

boolean_type = SampleAttributeType.find_or_initialize_by(title: 'Boolean')
boolean_type.update_attributes(base_type: Seek::Samples::BaseType::BOOLEAN)

int_type = SampleAttributeType.find_or_initialize_by(title: 'Integer')
int_type.update_attributes(base_type: Seek::Samples::BaseType::INTEGER, placeholder: '1')

float_type = SampleAttributeType.find_or_initialize_by(title: 'Real number')
float_type.update_attributes(base_type: Seek::Samples::BaseType::FLOAT, placeholder: '0.5')

date_type = SampleAttributeType.find_or_initialize_by(title: 'Date')
date_type.update_attributes(base_type: Seek::Samples::BaseType::DATE, placeholder: 'January 1, 2015')

string_type = SampleAttributeType.find_or_initialize_by(title: 'String')
string_type.update_attributes(base_type: Seek::Samples::BaseType::STRING)

cv_type = SampleAttributeType.find_or_initialize_by(title: 'Controlled Vocabulary')
cv_type.update_attributes(base_type: Seek::Samples::BaseType::CV)

text_type = SampleAttributeType.find_or_initialize_by(title: 'Text')
text_type.update_attributes(base_type: Seek::Samples::BaseType::TEXT, placeholder: '1')


# Studyhub resource type controlled vocabs
resource_type_attributes = []
StudyhubResourceType.all.each do |type|
  resource_type_attributes << { label: type.title }
end




def create_sample_controlled_vocab_terms_attributes(array)
  attributes = []
  array.each do |type|
    attributes << { label: type }
  end
  attributes
end

disable_authorization_checks do

  #resource_type
  resource_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: resource_type_attributes
  )

  # resource_type_general
  resource_type_general_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Type General').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Audiovisual', 'Book', 'Book chapter', 'Collection', 'Computational notebook',
                                                                                               'Conference paper', 'Conference proceeding', 'Data paper', 'Dataset',
                                                                                               'Dissertation', 'Event', 'Image', 'Interactive resource', 'Journal', 'Journal article',
                                                                                               'Model', 'Output management plan', 'Peer review', 'Physical object', 'Preprint',
                                                                                               'Report', 'Service', 'Software', 'Sound', 'Standard', 'Text', 'Workflow', 'Other'])
  )

  # resource_language
  resource_language_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Language').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[EN DE FR ES Other])
  )

  # resource_use_rights_label
  resource_use_rights_label_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Use Rights Label').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['CC0 1.0 (Creative Commons Zero v1.0 Universal)',
                                                                                               'CC BY 4.0 (Creative Commons Attribution 4.0 International)',
                                                                                               'CC BY-NC 4.0 (Creative Commons Attribution Non Commercial 4.0 International)',
                                                                                               'CC BY-SA 4.0 (Creative Commons Attribution Share Alike 4.0 International)',
                                                                                               'CC BY-NC-SA 4.0 (Creative Commons Attribution Non Commercial Share Alike 4.0 International)',
                                                                                               'All rights reserved',
                                                                                               'Other',
                                                                                               'Not applicable']))
  # id_type
  id_type_cv = SampleControlledVocab.where(title: 'NFDI4Health ID Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[arXiv bibcode DOI EAN13 EISSN Handle ISBN ISSN ISTC LISSN LSID PMID
PURL URL URN w3id DRKS UTN ISRCTN EudraCT EUDAMED NCT(ClinicalTrials.gov) NFDI4Health Other])

  )

  # id_resource_type_general
  id_resource_type_general_cv = SampleControlledVocab.where(title: 'NFDI4Health ID Resource Type General').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Audiovisual', 'Book', 'Book chapter', 'Collection', 'Computational notebook', 'Conference paper',
                                                                                               'Conference proceeding', 'Data paper', 'Dataset', 'Dissertation', 'Event', 'Image', 'Interactive resource',
                                                                                               'Journal', 'Journal article', 'Model', 'Output management plan', 'Peer review', 'Physical object', 'Preprint',
                                                                                               'Report', 'Service', 'Software', 'Sound', 'Standard', 'Text', 'Workflow', 'Other'])
  )

  # id_relation_type
  id_relation_types_cv = SampleControlledVocab.where(title: 'NFDI4Health ID Relation Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['is cited by', 'cites', 'is supplement to', 'is supplemented by', 'is continued by', 'continues', 'is described by',
                                                                                               'describes', 'has metadata', 'is metadata for', 'has version', 'is version of', 'is new version of', 'is previous version of',
                                                                                               'is part of', 'has part', 'is referenced by', 'references', 'is documented by', 'documents', 'is compiled by', 'compiles',
                                                                                               'is variant form of', 'is original form of', 'is identical to', 'is reviewed by', 'reviews', 'is derived from', 'is source of',
                                                                                               'is required by', 'requires', 'is obsoleted by', 'obsoletes', 'has grant number', 'has alternate ID'])
  )


  # ************************ role related CV begin *********************************

  # role_type
  role_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Contact person', 'Principal investigator', 'Creator/Author', 'Funder(public)', 'Funder(private)',
                                                                                               'Sponsor (primary)', 'Sponsor (secondary)', 'Sponsor-Investigator', 'Data collector', 'Data curator',
                                                                                               'Data manager', 'Distributor', 'Editor', 'Hosting institution', 'Producer', 'Project leader', 'Project manager',
                                                                                               'Project member', 'Publisher', 'Registration agency', 'Registration authority', 'Related person', 'Researcher',
                                                                                               'Research group', 'Rights holder', 'Supervisor', 'Work package leader', 'Other']))


  # role_name_type
  role_name_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Name Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Personal Organisational]))

  # role_name_personal_title
  role_name_personal_title_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Name Personal Title').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Mr.', 'Ms.', 'Dr.', 'Prof. Dr.', 'Other']))

  # role_name_identifier_scheme
  role_name_identifier_scheme_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Name Identifier Scheme').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[ORCID ROR GRID ISNI]))


  # role_affiliation_identifier_scheme
  role_affiliation_identifier_scheme_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Affiliation Identifier Scheme').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[ROR GRID ISNI]))

  # ************************ role related CV end *********************************

  # ************************ study design related CV begin *********************************


  # study_primary_design
  study_primary_design_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Primary Design').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Non-interventional Interventional])
  )

  # study_conditions_classification
  study_conditions_classification_cv = SampleControlledVocab.where(title: 'NFDI4Health Conditions Classification').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['MeSH', 'ICD-10', 'MedDRA', 'SNOMED CT',
                                                                                               'Other vocabulary', 'Free text'])
  )

  # study_ethics_commitee_approval
  study_ethics_commitee_approval_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Ethics Commitee Approval').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Request for approval not yet submitted', 'Request submitted, approval pending',
                                                                                               'Request submitted, approval granted', 'Request submitted, exempt granted',
                                                                                               'Request submitted, approval denied', 'Approval not required', 'Study withdrawn prior to decision on approval',
                                                                                               'Unknown'])
  )

  # study_status_enrolling_by_invitation
  study_status_enrolling_by_invitation_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status Enrolling By Invitation').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No', 'Not applicable'])
  )

  # study_status_when_intervention
  study_status_when_intervention_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status When Intervention').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Intervention ongoing', 'Intervention completed', 'Follow-up ongoing'])
  )

  # study_status_halted_stage
  study_status_halted_stage_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status Halted Stage').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes([
                                                                                                'At the planning stage',
                                                                                                'Ongoing (I): Recruitment ongoing, but data collection not yet started',
                                                                                                'Ongoing (II): Recruitment and data collection ongoing',
                                                                                                'Ongoing (III): Recruitment completed, but data collection ongoing',
                                                                                                'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing'])
  )

  # study_recruitment_status_register
  study_recruitment_status_register_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Recruitment Status Register').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Not yet recruiting', 'Recruiting', 'Enrolling by invitation', 'Active, not recruiting', 'Completed',
                                                                                               'Suspended', 'Terminated', 'Withdrawn', 'Other'])
  )



  # study_type_interventional
  study_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes([])
  )

  # study_primary_purpose
  study_primary_purpose_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Primary Purpose').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Treatment', 'Prevention', 'Prognostic', 'Diagnostic', 'Supportive Care', 'Screening', 'Health Services Research',
                                                                                               'Basic Science/Physiological study', 'Device Feasibility', 'Pharmacogenetics', 'Pharmacogenomics', 'Health Economics', 'Other'])
  )



  # study_centers
  study_centers_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Centers').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      %w[Monocentric Multicentric])
  )

  # study_subject
  study_subject_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Subject').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Person',  'Animal', 'Practitioner', 'Device', 'Medication', 'Substance', 'Organization', 'Family',
       'Household', 'Event/Process', 'Geographic unit', 'Time unit', 'Text unit', 'Group', 'Object', 'Pathogens', 'Twins',
       'Other', 'Unknown'])
  )

  # study_status
  study_status_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['At the planning stage',
       'Ongoing (I): Recruitment ongoing, but data collection not yet started',
       'Ongoing (II): Recruitment and data collection ongoing',
       'Ongoing (III): Recruitment completed, but data collection ongoing',
       'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing',
       'Suspended: Recruitment, data collection, or data quality management, halted, but potentially will resume',
       'Terminated: Recruitment, data collection, data and quality management halted prematurely and will not resume',
       'Completed: Recruitment, data collection, and data quality management completed normally',
       'Other'])
  )

  # study_eligibility_gender
  study_eligibility_gender_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Gender').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Male', 'Female', 'Diverse', 'Not applicable'])
  )

  # study_sampling
  study_sampling_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Sampling').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Total universe/Complete enumeration', 'Probability', 'Probability (Simple random)', 'Probability (Systematic random)', 'Probability (Stratified)',
       'Probability (Stratified: Proportional)', 'Probability (Stratified: Disproportional)', 'Probability (Cluster)', 'Probability (Cluster: Simple random)',
       'Probability (Cluster: Stratified random)', 'Probability (Multistage)', 'Non-probability', 'Non-probability (Availability)', 'Non-probability (Purposive)', 'Non-probability (Quota)',
       'Non-probability (Respondent-assisted)', 'Mixed probability and non-probability', 'Other', 'Unknown', 'Not applicable'])
  )

  # study_data_source
  study_data_source_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Source').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Blood', 'Buccal cells', 'Cord blood', 'DNA', 'Faeces', 'Hair', 'Immortalized cell lines', 'Isolated pathogen', 'Nail', 'Plasma', 'RNA', 'Saliva', 'Serum', 'Tissue (Frozen)', 'Tissue (FFPE)',
       'Urine', 'Other biological samples', 'Administrative databases', 'Cognitive measurements', 'Genealogical records', 'Imaging data (ultrasound)', 'Imaging data (MRI)', 'Imaging data (MRI, radiography)',
       'Imaging data (CT)', 'Other imaging data', 'Medical records', 'Registries', 'Interview', 'Questionnaire', 'Physiological/Biochemical measurements', 'Genomics', 'Metabolomics', 'Transcriptomics',
       'Proteomics', 'Other omics technology', 'Other'])
  )

  # study_data_sharing_plan_generally
  study_data_sharing_plan_generally_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Sharing Plan Generally').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes, there is a plan to make data available.',
                                                                                                'No, there is no plan to make data available.',
                                                                                                'Undecided, it is not yet known if data will be made available.'])
  )


  # study_data_sharing_plan_supporting_information
  study_data_sharing_plan_supporting_information_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Sharing Plan Supporting Information').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Data dictionary', 'Study protocol', 'Protocol amendment', 'Statistical analysis plan',
                                                                                               'Analytic code', 'Informed consent form', 'Clinical study report', 'Manual of operations (SOP)',
                                                                                               'Case report form (template)', 'Questionnaire (template)', 'Code book', 'Other'])
  )

  # study_time_perspective
  study_time_perspective_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Time Perspective').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Retrospective Prospective Cross-sectional Other])
  )

  # study_phase
  study_phase_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Phase').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Early-phase-1', 'Phase-1', 'Phase-1-phase-2', 'Phase-2', 'Phase-2a', 'Phase-2b',
                                                                                               'Phase-2-phase-3', 'Phase-3', 'Phase-3a', 'Phase-3b', 'Phase-4', 'Other', 'Not applicable'])
  )


  # study_masking_roles
  study_masking_roles_cv =SampleControlledVocab.where(title: 'NFDI4Health Study Masking Roles').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Participant', 'Care Provider', 'Investigator', 'Outcomes Assessor'])
  )

  # study_allocation
  study_allocation_cv =SampleControlledVocab.where(title: 'NFDI4Health Study Allocation').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Randomized', 'Nonrandomized', ' Not applicable (for single-arm trials)'])
  )

  # study_off_label_use
  study_off_label_use_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Off Label Use').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No', 'Not applicable'])
  )

  # study_arm_group_type
  study_arm_group_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Arm Group Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Experimental', 'Active comparator', 'Placebo comparator',
                                                                                               'Sham comparator', 'No intervention', 'Other'])
    )

  # study_intervention_type
  study_intervention_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Intervention Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Drug (including placebo)', 'Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery',
                                                                                               'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)',
                                                                                               'Dietary supplement (e.g., vitamins, minerals)',
                                                                                               'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)',
                                                                                               'Diagnostic test (e.g., imaging, in-vitro)', 'Other'])
  )

  # study_outcome_type
  study_outcome_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Outcome Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Primary', ' Secondary', 'Other'])
  )

  # study_biospecimen_retention
  study_biospecimen_retention_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Biospecimen Retention').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['None retained', 'Samples with DNA', 'Samples without DNA'])
  )

  # ************************ study design related CV end ***********************


  # ************************ provenance related CV begin ***********************
  data_source_cv = SampleControlledVocab.where(title: 'NFDI4Health Data Source').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Automatically uploaded: ClinicalTrials.gov', 'Automatically uploaded: DRKS', 'Automatically uploaded: ICTRP',
       'Automatically uploaded: Other', 'Manually collected'])
  )
  # ************************ provenance related CV end ***********************


  # #############################################################################################
  # Custom Metadata Attributes of NFDI4Health Studyhub Resource General Custom Metadata Attribute
  # #############################################################################################

  resource_type_general = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_type_general')
  resource_type_general.update_attributes(
    title: 'resource_type_general', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_type_general_cv,
    description: attribute_descriptions['resource_type_general'], label: attribute_headings['resource_type_general'], pos:1
  )

  # ******************************** ResourceKeywords Group ***********************

  resource_keywords = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_keywords')
  resource_keywords.update_attributes(
    title: 'resource_keywords', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['resource_keywords'], label: attribute_headings['resource_keywords'], pos:2
  )


  resource_keywords_label = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_keywords_label')
  resource_keywords_label.update_attributes(
    title: 'resource_keywords_label', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['resource_keywords_label'], label: attribute_headings['resource_keywords_label'], pos:3
  )


  resource_keywords_label_code = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_keywords_label_code')
  resource_keywords_label_code.update_attributes(
    title: 'resource_keywords_label_code', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['resource_keywords_label_code'], label: attribute_headings['resource_keywords_label_code'], pos:4
  )
  # ****************************************************************


  resource_language = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_language')
  resource_language.update_attributes(
    title: 'resource_language', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: resource_language_cv,
    description: attribute_descriptions['resource_language'], label: attribute_headings['resource_language'], pos:5
  )

  resource_web_page = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_web_page')
  resource_web_page.update_attributes(
    title: 'resource_web_page', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['resource_web_page'], label: attribute_headings['resource_web_page'], pos:6
  )


  resource_version = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_version')
  resource_version.update_attributes(
    title: 'resource_version', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['resource_version'], label: attribute_headings['resource_version'], pos:7
  )


  resource_format = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_format')
  resource_format.update_attributes(
    title: 'resource_format', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['resource_format'], label: attribute_headings['resource_format'], pos:8
  )

  resource_use_rights_label = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_use_rights_label')
  resource_use_rights_label.update_attributes(
    title: 'resource_use_rights_label', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_label_cv,
    description: attribute_descriptions['resource_use_rights_label'], label: attribute_headings['resource_use_rights_label'], pos:9
  )

  resource_use_rights_description = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_use_rights_description')
  resource_use_rights_description.update_attributes(
    title: 'resource_use_rights_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['resource_use_rights_description'], label: attribute_headings['resource_use_rights_description'], pos:10
  )

  resource_use_rights_authors_confirmation_1 = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_use_rights_authors_confirmation_1')
  resource_use_rights_authors_confirmation_1.update_attributes(
    title: 'resource_use_rights_authors_confirmation_1', required: true, sample_attribute_type: boolean_type,
    description: attribute_descriptions['resource_use_rights_authors_confirmation_1'],
    label: attribute_headings['resource_use_rights_authors_confirmation_1'], pos:11
  )

  resource_use_rights_authors_confirmation_2 = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_use_rights_authors_confirmation_2')
  resource_use_rights_authors_confirmation_2.update_attributes(
    title: 'resource_use_rights_authors_confirmation_2', required: true, sample_attribute_type: boolean_type,
    description: attribute_descriptions['resource_use_rights_authors_confirmation_2'],
    label: attribute_headings['resource_use_rights_authors_confirmation_2'], pos:12
  )

  resource_use_rights_authors_confirmation_3 = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_use_rights_authors_confirmation_3')
  resource_use_rights_authors_confirmation_3.update_attributes(
    title: 'resource_use_rights_authors_confirmation_3', required: true, sample_attribute_type: boolean_type,
    description: attribute_descriptions['resource_use_rights_authors_confirmation_3'],
    label: attribute_headings['resource_use_rights_authors_confirmation_3'], pos:13
  )

  resource_use_rights_support_by_licencing = CustomMetadataAttribute.find_or_initialize_by(title: 'resource_use_rights_support_by_licencing')
  resource_use_rights_support_by_licencing.update_attributes(
    title: 'resource_use_rights_support_by_licencing', required: true, sample_attribute_type: boolean_type,
    description: attribute_descriptions['resource_use_rights_support_by_licencing'],
    label: attribute_headings['resource_use_rights_support_by_licencing'], pos:14
  )

  cmt_studyhub_resource_general = CustomMetadataType.find_or_initialize_by(title: 'NFDI4Health Studyhub Resource General', supported_type: 'StudyhubResource')
  cmt_studyhub_resource_general.update_attributes(
    title: 'NFDI4Health Studyhub Resource General', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [
      resource_type_general, resource_keywords, resource_keywords_label, resource_keywords_label_code, resource_language, resource_web_page, resource_version,
      resource_format, resource_use_rights_label, resource_use_rights_description, resource_use_rights_authors_confirmation_1, resource_use_rights_authors_confirmation_2,
      resource_use_rights_authors_confirmation_3, resource_use_rights_support_by_licencing
    ]
  )


  # #############################################################################################
  # Custom Metadata Attributes of NFDI4Health Studyhub Resource StudyDesign General
  # #############################################################################################

  study_primary_design = CustomMetadataAttribute.find_or_initialize_by(title: 'study_primary_design')
  study_primary_design.update_attributes(
    title: 'study_primary_design', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_primary_design_cv,
    description: attribute_descriptions['study_primary_design'], label: attribute_headings['study_primary_design'], pos:1
  )

  study_type = CustomMetadataAttribute.find_or_initialize_by(title: 'study_type')
  study_type.update_attributes(
    title: 'study_type', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_type_cv,
    description: attribute_descriptions['study_type'], label: attribute_headings['study_type'], pos:2
  )


  study_type_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_type_description')
  study_type_description.update_attributes(
    title: 'study_type_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_type_description'], label: attribute_headings['study_type_description'], pos:4
  )

  # ****************** StudyDesignConditions ******************
  study_conditions = CustomMetadataAttribute.find_or_initialize_by(title: 'study_conditions')
  study_conditions.update_attributes(
    title: 'study_conditions', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_conditions'], label: attribute_headings['study_conditions'], pos:5
  )

  study_conditions_classification = CustomMetadataAttribute.find_or_initialize_by(title: 'study_conditions_classification')
  study_conditions_classification.update_attributes(
    title: 'study_conditions_classification', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_conditions_classification_cv,
    description: attribute_descriptions['study_conditions_classification'], label: attribute_headings['study_conditions_classification'], pos:6
  )


  study_conditions_classification_code = CustomMetadataAttribute.find_or_initialize_by(title: 'study_conditions_classification_code')
  study_conditions_classification_code.update_attributes(
    title: 'study_conditions_classification_code', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_conditions_classification_code'], label: attribute_headings['study_conditions_classification_code'], pos:7
  )
  # ****************************************************************

  study_ethics_commitee_approval = CustomMetadataAttribute.find_or_initialize_by(title: 'study_ethics_commitee_approval')
  study_ethics_commitee_approval.update_attributes(
    title: 'study_ethics_commitee_approval', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_ethics_commitee_approval_cv,
    description: attribute_descriptions['study_ethics_commitee_approval'], label: attribute_headings['study_ethics_commitee_approval'], pos:8
  )

  study_status = CustomMetadataAttribute.find_or_initialize_by(title: 'study_status')
  study_status.update_attributes(
    title: 'study_status', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_cv,
    description: attribute_descriptions['study_status'], label: attribute_headings['study_status'], pos:9
  )

  study_status_enrolling_by_invitation = CustomMetadataAttribute.find_or_initialize_by(title: 'study_status_enrolling_by_invitation')
  study_status_enrolling_by_invitation.update_attributes(
    title: 'study_status_enrolling_by_invitation', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_enrolling_by_invitation_cv,
    description: attribute_descriptions['study_status_enrolling_by_invitation'], label: attribute_headings['study_status_enrolling_by_invitation'], pos:10
  )


  study_status_when_intervention = CustomMetadataAttribute.find_or_initialize_by(title: 'study_status_when_intervention')
  study_status_when_intervention.update_attributes(
    title: 'study_status_when_intervention', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_when_intervention_cv,
    description: attribute_descriptions['study_status_when_intervention'], label: attribute_headings['study_status_when_intervention'], pos:11
  )


  study_status_halted_stage = CustomMetadataAttribute.find_or_initialize_by(title: 'study_status_halted_stage')
  study_status_halted_stage.update_attributes(
    title: 'study_status_halted_stage', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_halted_stage_cv,
    description: attribute_descriptions['study_status_halted_stage'], label: attribute_headings['study_status_halted_stage'], pos:12
  )

  study_status_halted_reason = CustomMetadataAttribute.find_or_initialize_by(title: 'study_status_halted_reason')
  study_status_halted_reason.update_attributes(
    title: 'study_status_halted_reason', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_status_halted_reason'], label: attribute_headings['study_status_halted_reason'], pos:13
  )

  study_recruitment_status_register = CustomMetadataAttribute.find_or_initialize_by(title: 'study_recruitment_status_register')
  study_recruitment_status_register.update_attributes(
    title: 'study_recruitment_status_register', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_recruitment_status_register_cv,
    description: attribute_descriptions['study_recruitment_status_register'], label: attribute_headings['study_recruitment_status_register'], pos:14
  )

  study_start_date = CustomMetadataAttribute.find_or_initialize_by(title: 'study_start_date')
  study_start_date.update_attributes(
    title: 'study_start_date', required: false, sample_attribute_type: date_type,
    description: attribute_descriptions['study_start_date'], label: attribute_headings['study_start_date'], pos:15
  )


  study_end_date = CustomMetadataAttribute.find_or_initialize_by(title: 'study_end_date')
  study_end_date.update_attributes(
    title: 'study_end_date', required: false, sample_attribute_type: date_type,
    description: attribute_descriptions['study_end_date'], label: attribute_headings['study_end_date'], pos:16
  )

  study_centers = CustomMetadataAttribute.find_or_initialize_by(title: 'study_centers')
  study_centers.update_attributes(
    title: 'study_centers', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_centers_cv,
    description: attribute_descriptions['study_centers'], label: attribute_headings['study_centers'], pos:19
  )

  study_centers_number = CustomMetadataAttribute.find_or_initialize_by(title: 'study_centers_number')
  study_centers_number.update_attributes(
    title: 'study_centers_number', required: false, sample_attribute_type: int_type,
    description: attribute_descriptions['study_centers_number'], label: attribute_headings['study_centers_number'], pos:20
  )


  study_subject = CustomMetadataAttribute.find_or_initialize_by(title: 'study_subject')
  study_subject.update_attributes(
    title: 'study_subject', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_subject_cv,
    description: attribute_descriptions['study_subject'], label: attribute_headings['study_subject'], pos:21
  )

  study_sampling = CustomMetadataAttribute.find_or_initialize_by(title: 'study_sampling')
  study_sampling.update_attributes(
    title: 'study_sampling', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_sampling_cv,
    description: attribute_descriptions['study_sampling'], label: attribute_headings['study_sampling'], pos:22
  )

  study_data_source = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_source')
  study_data_source.update_attributes(
    title: 'study_data_source', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_data_source_cv,
    description: attribute_descriptions['study_data_source'], label: attribute_headings['study_data_source'], pos:23
  )



  study_data_source_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_source_description')
  study_data_source_description.update_attributes(
    title: 'study_data_source_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_data_source_description'], label: attribute_headings['study_data_source_description'], pos:24
  )

  study_eligibility_age_min = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_age_min')
  study_eligibility_age_min.update_attributes(
    title: 'study_eligibility_age_min', required: false, sample_attribute_type: float_type,
    description: attribute_descriptions['study_eligibility_age_min'], label: attribute_headings['study_eligibility_age_min'], pos:25
  )

  study_eligibility_age_min_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_age_min_description')
  study_eligibility_age_min_description.update_attributes(
    title: 'study_eligibility_age_min_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_eligibility_age_min_description'], label: attribute_headings['study_eligibility_age_min_description'], pos:26
  )

  study_eligibility_age_max = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_age_max')
  study_eligibility_age_max.update_attributes(
    title: 'study_eligibility_age_max', required: false, sample_attribute_type: float_type,
    description: attribute_descriptions['study_eligibility_age_max'], label: attribute_headings['study_eligibility_age_max'], pos:27
  )

  study_eligibility_age_max_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_age_max_description')
  study_eligibility_age_max_description.update_attributes(
    title: 'study_eligibility_age_max_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_eligibility_age_max_description'], label: attribute_headings['study_eligibility_age_max_description'], pos:28
  )
  study_eligibility_gender = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_gender')
  study_eligibility_gender.update_attributes(
    title: 'study_eligibility_gender', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_eligibility_gender_cv,
    description: attribute_descriptions['study_eligibility_gender'], label: attribute_headings['study_eligibility_gender'], pos:29
  )

  study_eligibility_inclusion_criteria = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_inclusion_criteria')
  study_eligibility_inclusion_criteria.update_attributes(
    title: 'study_eligibility_inclusion_criteria', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_eligibility_inclusion_criteria'], label: attribute_headings['study_eligibility_inclusion_criteria'], pos:30
  )

  study_eligibility_exclusion_criteria = CustomMetadataAttribute.find_or_initialize_by(title: 'study_eligibility_exclusion_criteria')
  study_eligibility_exclusion_criteria.update_attributes(
    title: 'study_eligibility_exclusion_criteria', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_eligibility_exclusion_criteria'], label: attribute_headings['study_eligibility_exclusion_criteria'], pos:31
  )
  study_population = CustomMetadataAttribute.find_or_initialize_by(title: 'study_population')
  study_population.update_attributes(
    title: 'study_population', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_population'], label: attribute_headings['study_population'], pos:32
  )

  study_target_sample_size = CustomMetadataAttribute.find_or_initialize_by(title: 'study_target_sample_size')
  study_target_sample_size.update_attributes(
    title: 'study_target_sample_size', required: false, sample_attribute_type: int_type,
    description: attribute_descriptions['study_target_sample_size'], label: attribute_headings['study_target_sample_size'], pos:33
  )

  study_obtained_sample_size = CustomMetadataAttribute.find_or_initialize_by(title: 'study_obtained_sample_size')
  study_obtained_sample_size.update_attributes(
    title: 'study_obtained_sample_size', required: false, sample_attribute_type: int_type,
    description: attribute_descriptions['study_obtained_sample_size'], label: attribute_headings['study_obtained_sample_size'], pos:34
  )

  study_age_min_examined = CustomMetadataAttribute.find_or_initialize_by(title: 'study_age_min_examined')
  study_age_min_examined.update_attributes(
    title: 'study_age_min_examined', required: false, sample_attribute_type: float_type,
    description: attribute_descriptions['study_age_min_examined'], label: attribute_headings['study_age_min_examined'], pos:35
  )

  study_age_min_examined_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_age_min_examined_description')
  study_age_min_examined_description.update_attributes(
    title: 'study_age_min_examined_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_age_min_examined_description'], label: attribute_headings['study_age_min_examined_description'], pos:36
  )

  study_age_max_examined = CustomMetadataAttribute.find_or_initialize_by(title: 'study_age_max_examined')
  study_age_max_examined.update_attributes(
    title: 'study_age_max_examined', required: false, sample_attribute_type: float_type,
    description: attribute_descriptions['study_age_max_examined'], label: attribute_headings['study_age_max_examined'], pos:37
  )

  study_age_max_examined_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_age_max_examined_description')
  study_age_max_examined_description.update_attributes(
    title: 'study_age_max_examined_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_age_max_examined_description'], label: attribute_headings['study_age_max_examined_description'], pos:38
  )

  study_hypothesis = CustomMetadataAttribute.find_or_initialize_by(title: 'study_hypothesis')
  study_hypothesis.update_attributes(
    title: 'study_hypothesis', required: false , sample_attribute_type: text_type,
    description: attribute_descriptions['study_hypothesis'], label: attribute_headings['study_hypothesis'], pos:39
  )
  # ****************** StudyDesignOutcomes ******************

  study_outcomes = CustomMetadataAttribute.find_or_initialize_by(title: 'study_outcomes')
  study_outcomes.update_attributes(
    title: 'study_outcomes', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_outcomes'], label: attribute_headings['study_outcomes'], pos:40
  )

  study_outcome_type = CustomMetadataAttribute.find_or_initialize_by(title: 'study_outcome_type')
  study_outcome_type.update_attributes(
    title: 'study_outcome_type', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_outcome_type_cv,
    description: attribute_descriptions['study_outcome_type'], label: attribute_headings['study_outcome_type'], pos:41
  )

  study_outcome_title = CustomMetadataAttribute.find_or_initialize_by(title: 'study_outcome_title')
  study_outcome_title.update_attributes(
    title: 'study_outcome_title', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_outcome_title'], label: attribute_headings['study_outcome_title'], pos:42
  )

  study_outcome_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_outcome_description')
  study_outcome_description.update_attributes(
    title: 'study_outcome_description', required: false , sample_attribute_type: text_type,
    description: attribute_descriptions['study_outcome_description'], label: attribute_headings['study_outcome_description'], pos:43
  )

  study_outcome_time_frame = CustomMetadataAttribute.find_or_initialize_by(title: 'study_outcome_time_frame')
  study_outcome_time_frame.update_attributes(
    title: 'study_outcome_time_frame', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_outcome_time_frame'], label: attribute_headings['study_outcome_time_frame'], pos:44
  )

  # ****************** StudyDesignOutcomes ******************

  study_design_comment = CustomMetadataAttribute.find_or_initialize_by(title: 'study_design_comment')
  study_design_comment.update_attributes(
    title: 'study_design_comment', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_design_comment'], label: attribute_headings['study_design_comment'], pos:45
  )

  study_data_sharing_plan_generally = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_sharing_plan_generally')
  study_data_sharing_plan_generally.update_attributes(
    title: 'study_data_sharing_plan_generally', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_data_sharing_plan_generally_cv,
    description: attribute_descriptions['study_data_sharing_plan_generally'], label: attribute_headings['study_data_sharing_plan_generally'], pos:46
  )

  study_data_sharing_plan_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_sharing_plan_description')
  study_data_sharing_plan_description.update_attributes(
    title: 'study_data_sharing_plan_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_data_sharing_plan_description'], label: attribute_headings['study_data_sharing_plan_description'], pos:47
  )

  study_data_sharing_plan_supporting_information = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_sharing_plan_supporting_information')
  study_data_sharing_plan_supporting_information.update_attributes(
    title: 'study_data_sharing_plan_supporting_information', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_data_sharing_plan_supporting_information_cv,
    description: attribute_descriptions['study_data_sharing_plan_supporting_information'], label: attribute_headings['study_data_sharing_plan_supporting_information'], pos:48
  )

  study_data_sharing_plan_time_frame = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_sharing_plan_time_frame')
  study_data_sharing_plan_time_frame.update_attributes(
    title: 'study_data_sharing_plan_time_frame', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_data_sharing_plan_time_frame'], label: attribute_headings['study_data_sharing_plan_time_frame'], pos:49
  )

  study_data_sharing_plan_access_criteria = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_sharing_plan_access_criteria')
  study_data_sharing_plan_access_criteria.update_attributes(
    title: 'study_data_sharing_plan_access_criteria', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_data_sharing_plan_access_criteria'], label: attribute_headings['study_data_sharing_plan_access_criteria'], pos:50
  )

  study_data_sharing_plan_url = CustomMetadataAttribute.find_or_initialize_by(title: 'study_data_sharing_plan_url')
  study_data_sharing_plan_url.update_attributes(
    title: 'study_data_sharing_plan_url', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_data_sharing_plan_url'], label: attribute_headings['study_data_sharing_plan_url'], pos:51
  )

  study_region = CustomMetadataAttribute.find_or_initialize_by(title: 'study_region')
  study_region.update_attributes(
    title: 'study_region', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_region'], label: attribute_headings['study_region'], pos:18
  )


  cmt_studyhub_studydesign_general = CustomMetadataType.find_or_initialize_by(title: 'NFDI4Health Studyhub Resource StudyDesign General', supported_type: 'StudyhubResource')
  cmt_studyhub_studydesign_general.update_attributes(
    title: 'NFDI4Health Studyhub Resource StudyDesign General', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [
      study_primary_design, study_type, study_type_description, study_conditions, study_conditions_classification, study_conditions_classification_code,
      study_ethics_commitee_approval, study_status, study_status_enrolling_by_invitation, study_status_when_intervention, study_status_halted_stage, study_status_halted_reason,
      study_recruitment_status_register, study_start_date, study_end_date, study_centers, study_centers_number, study_subject, study_sampling, study_data_source, study_data_source_description,
      study_eligibility_age_min, study_eligibility_age_min_description, study_eligibility_age_max, study_eligibility_age_max_description, study_eligibility_gender, study_eligibility_inclusion_criteria,
      study_eligibility_exclusion_criteria, study_population, study_target_sample_size, study_obtained_sample_size, study_age_min_examined, study_age_min_examined_description, study_age_max_examined,
      study_age_max_examined_description, study_hypothesis, study_outcomes, study_outcome_type, study_outcome_title, study_outcome_description, study_outcome_time_frame,
      study_design_comment, study_data_sharing_plan_generally, study_data_sharing_plan_description, study_data_sharing_plan_supporting_information, study_data_sharing_plan_time_frame,
      study_data_sharing_plan_access_criteria, study_data_sharing_plan_url, study_region
    ]
  )

  # ################################################################################################
  # Custom Metadata Attributes of NFDI4Health Studyhub Resource StudyDesign Non Interventional Study
  # ################################################################################################

  study_time_perspective = CustomMetadataAttribute.find_or_initialize_by(title: 'study_time_perspective')
  study_time_perspective.update_attributes(
    title: 'study_time_perspective', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_time_perspective_cv,
    description: attribute_descriptions['study_time_perspective'], label: attribute_headings['study_time_perspective'], pos:1
  )


  study_target_follow_up_duration = CustomMetadataAttribute.find_or_initialize_by(title: 'study_target_follow-up_duration')
  study_target_follow_up_duration.update_attributes(
    title: 'study_target_follow-up_duration', required: false, sample_attribute_type: float_type,
    description: attribute_descriptions['study_target_follow-up_duration'], label: attribute_headings['study_target_follow-up_duration'], pos:2
  )

  study_biospecimen_retention = CustomMetadataAttribute.find_or_initialize_by(title: 'study_biospecimen_retention')
  study_biospecimen_retention.update_attributes(
    title: 'study_biospecimen_retention', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_biospecimen_retention_cv,
    description: attribute_descriptions['study_biospecimen_retention'], label: attribute_headings['study_biospecimen_retention'], pos:3
  )

  study_biospecomen_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_biospecomen_description')
  study_biospecomen_description.update_attributes(
    title: 'study_biospecomen_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_biospecomen_description'], label: attribute_headings['study_biospecomen_description'], pos:4
  )



  cmt_studydesign_non_interventional_study = CustomMetadataType.find_or_initialize_by(title: 'NFDI4Health Studyhub Resource StudyDesign Non Interventional Study', supported_type: 'StudyhubResource')
  cmt_studydesign_non_interventional_study.update_attributes(
    title: 'NFDI4Health Studyhub Resource StudyDesign Non Interventional Study', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [
      study_time_perspective, study_target_follow_up_duration, study_biospecimen_retention, study_biospecomen_description
    ]
  )


  # #############################################################################################
  # Custom Metadata Attributes of NFDI4Health Studyhub Resource StudyDesign Interventional Study
  # #############################################################################################


  study_primary_purpose = CustomMetadataAttribute.find_or_initialize_by(title: 'study_primary_purpose')
  study_primary_purpose.update_attributes(
    title: 'study_primary_purpose', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_primary_purpose_cv,
    description: attribute_descriptions['study_primary_purpose'], label: attribute_headings['study_primary_purpose'], pos:1
  )

  study_phase = CustomMetadataAttribute.find_or_initialize_by(title: 'study_phase')
  study_phase.update_attributes(
    title: 'study_phase', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_phase_cv,
    description: attribute_descriptions['study_phase'], label: attribute_headings['study_phase'], pos:2
  )

  study_masking = CustomMetadataAttribute.find_or_initialize_by(title: 'study_masking')
  study_masking.update_attributes(
    title: 'study_masking', required: false, sample_attribute_type: boolean_type,
    description: attribute_descriptions['study_masking'], label: attribute_headings['study_masking'], pos:3
  )

  study_masking_roles = CustomMetadataAttribute.find_or_initialize_by(title: 'study_masking_roles')
  study_masking_roles.update_attributes(
    title: 'study_masking_roles', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_masking_roles_cv,
    description: attribute_descriptions['study_masking_roles'], label: attribute_headings['study_masking_roles'], pos:4
  )

  study_masking_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_masking_description')
  study_masking_description.update_attributes(
    title: 'study_masking_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_masking_description'], label: attribute_headings['study_masking_description'], pos:5
  )

  study_allocation = CustomMetadataAttribute.find_or_initialize_by(title: 'study_allocation')
  study_allocation.update_attributes(
    title: 'study_allocation', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_allocation_cv,
    description: attribute_descriptions['study_allocation'], label: attribute_headings['study_allocation'], pos:6
  )


  study_off_label_use = CustomMetadataAttribute.find_or_initialize_by(title: 'study_off_label_use')
  study_off_label_use.update_attributes(
    title: 'study_off_label_use', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_off_label_use_cv,
    description: attribute_descriptions['study_off_label_use'], label: attribute_headings['study_off_label_use'], pos:7
  )

  # ****************** StudyArmGroups ******************

  interventional_study_design_arms = CustomMetadataAttribute.find_or_initialize_by(title: 'interventional_study_design_arms')
  interventional_study_design_arms.update_attributes(
    title: 'interventional_study_design_arms', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['interventional_study_design_arms'], label: attribute_headings['interventional_study_design_arms'], pos:8
  )

  study_arm_group_label = CustomMetadataAttribute.find_or_initialize_by(title: 'study_arm_group_label')
  study_arm_group_label.update_attributes(
    title: 'study_arm_group_label', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['study_arm_group_label'], label: attribute_headings['study_arm_group_label'], pos:9
  )

  study_arm_group_type = CustomMetadataAttribute.find_or_initialize_by(title: 'study_arm_group_type')
  study_arm_group_type.update_attributes(
    title: 'study_arm_group_type', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_arm_group_type_cv,
    description: attribute_descriptions['study_arm_group_type'], label: attribute_headings['study_arm_group_type'], pos:10
  )

  study_arm_group_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_arm_group_description')
  study_arm_group_description.update_attributes(
    title: 'study_arm_group_description', required: false, sample_attribute_type: text_type,
    description: attribute_descriptions['study_arm_group_description'], label: attribute_headings['study_arm_group_description'], pos:11
  )
  # ****************** StudyArmGroups ******************


  # ****************** StudyDesignIntervention ******************

  interventional_study_design_interventions = CustomMetadataAttribute.find_or_initialize_by(title: 'interventional_study_design_interventions')
  interventional_study_design_interventions.update_attributes(
    title: 'interventional_study_design_interventions', required: false, sample_attribute_type: string_type,
    description: attribute_descriptions['interventional_study_design_interventions'], label: attribute_headings['interventional_study_design_interventions'], pos:12
  )

  study_intervention_name = CustomMetadataAttribute.find_or_initialize_by(title: 'study_intervention_name')
  study_intervention_name.update_attributes(
    title: 'study_intervention_name', required: false , sample_attribute_type: string_type,
    description: attribute_descriptions['study_intervention_name'], label: attribute_headings['study_intervention_name'], pos:13
  )

  study_intervention_type = CustomMetadataAttribute.find_or_initialize_by(title: 'study_intervention_type')
  study_intervention_type.update_attributes(
    title: 'study_intervention_type', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_intervention_type_cv,
    description: attribute_descriptions['study_intervention_type'], label: attribute_headings['study_intervention_type'], pos:14
  )

  study_intervention_description = CustomMetadataAttribute.find_or_initialize_by(title: 'study_intervention_description')
  study_intervention_description.update_attributes(
    title: 'study_intervention_description', required: false , sample_attribute_type: text_type,
    description: attribute_descriptions['study_intervention_description'], label: attribute_headings['study_intervention_description'], pos:15
  )

  study_intervention_arm_group_label = CustomMetadataAttribute.find_or_initialize_by(title: 'study_intervention_arm_group_label')
  study_intervention_arm_group_label.update_attributes(
    title: 'study_intervention_arm_group_label', required: false , sample_attribute_type: string_type,
    description: attribute_descriptions['study_intervention_arm_group_label'], label: attribute_headings['study_intervention_arm_group_label'], pos:16
  )
  # ****************** StudyDesignIntervention ******************

  cmt_studydesign_interventional_study = CustomMetadataType.find_or_initialize_by(title: 'NFDI4Health Studyhub Resource StudyDesign Interventional Study', supported_type: 'StudyhubResource')
  cmt_studydesign_interventional_study.update_attributes(
    title: 'NFDI4Health Studyhub Resource StudyDesign Interventional Study', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [
      study_primary_purpose, study_phase, study_masking, study_masking_roles, study_masking_description, study_allocation, study_off_label_use, interventional_study_design_arms,
      study_arm_group_label, study_arm_group_type, study_arm_group_description, interventional_study_design_interventions, study_intervention_name, study_intervention_type,
      study_intervention_description, study_intervention_arm_group_label
    ]
  )

  # #############################################################################################
  # Custom Metadata Attributes of NFDI4Health Studyhub Resource Provenance
  # #############################################################################################

  data_source = CustomMetadataAttribute.find_or_initialize_by(title: 'data_source')
  data_source.update_attributes(
    title: 'data_source', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: data_source_cv, pos:1
  )

  cmt_studyhub_provenance = CustomMetadataType.find_or_initialize_by(title: 'NFDI4Health Studyhub Resource Provenance', supported_type: 'StudyhubResource')
  cmt_studyhub_provenance.update_attributes(
    title: 'NFDI4Health Studyhub Resource Provenance', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [data_source]
  )

end

