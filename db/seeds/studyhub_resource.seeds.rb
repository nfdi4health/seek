puts 'Seeded Studyhub Resource Types'
ActiveRecord::FixtureSet.create_fixtures(File.join(Rails.root, 'config/default_data'), 'studyhub_resource_types')
puts 'Seeded NFDI4Health Studyhub Resource Metadata'


configpath = File.join(Rails.root, 'config/default_data', 'studyhub_resource_attribute_descriptions.yml')
attribute_descriptions = YAML::load_file(configpath)

configpath = File.join(Rails.root, 'config/default_data', 'studyhub_resource_attribute_heading.yml')
attribute_headings = YAML::load_file(configpath)

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

  #resource_type_general
  resource_type_general_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Type General').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Audiovisual', 'Book','Book chapter', 'Collection', 'Computational notebook',
                                                                                               'Conference paper', 'Conference proceeding', 'Data paper', 'Dataset',
                                                                                               'Dissertation', 'Event', 'Image', 'Interactive resource','Journal','Journal article',
                                                                                               'Model', 'Output management plan', 'Peer review', 'Physical object', 'Preprint',
                                                                                               'Report', 'Service', 'Software', 'Sound', 'Standard', 'Text', 'Workflow', 'Other'])
  )

  # resource_language
  resource_language_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Language').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[EN DE FR ES Other])
  )

  #resource_use_rights_label
  resource_use_rights_label_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Use Rights Label').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['CC0 1.0 (Creative Commons Zero v1.0 Universal)',
                                                                                               'CC BY 4.0 (Creative Commons Attribution 4.0 International)',
                                                                                               'CC BY-NC 4.0 (Creative Commons Attribution Non Commercial 4.0 International)',
                                                                                               'CC BY-SA 4.0 (Creative Commons Attribution Share Alike 4.0 International)',
                                                                                               'CC BY-NC-SA 4.0 (Creative Commons Attribution Non Commercial Share Alike 4.0 International)',
                                                                                               'All rights reserved',
                                                                                               'Other',
                                                                                               'Not applicable']))


  #resource_use_rights_authors_confirmation_cv
  resource_use_rights_authors_confirmation_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Use Rights Author Confirmation').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No' ])
  )

  #resource_use_rights_support_by_licencing_cv
  resource_use_rights_support_by_licencing_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Use Rights Support By Licencing').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No' ])
  )

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


  #************************ role related CV begin *********************************

  # role_type
  role_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Contact person','Principal investigator','Creator/Author','Funder(public)','Funder(private)',
                                                                                               'Sponsor (primary)','Sponsor (secondary)','Sponsor-Investigator', 'Data collector', 'Data curator',
                                                                                               'Data manager', 'Distributor', 'Editor', 'Hosting institution', 'Producer', 'Project leader','Project manager',
                                                                                               'Project member', 'Publisher', 'Registration agency', 'Registration authority', 'Related person', 'Researcher',
                                                                                               'Research group', 'Rights holder', 'Supervisor', 'Work package leader', 'Other']))


  # role_name_type
  role_name_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Name Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Personal Organisational]))

  #role_name_personal_title
  role_name_personal_title_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Name Personal Title').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Mr.','Ms.','Dr.','Prof. Dr.','Other']))

  # role_name_identifier_scheme
  role_name_identifier_scheme_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Name Identifier Scheme').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[ORCID ROR GRID ISNI]))


  # role_affiliation_identifier_scheme
  role_affiliation_identifier_scheme_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Affiliation Identifier Scheme').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[ROR GRID ISNI]))

  #************************ role related CV end *********************************

  #************************ study design related CV begin *********************************


  #study_primary_design
  study_primary_design_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Primary Design').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Non-interventional Interventional])
  )

  #study_conditions_classification
  study_conditions_classification_cv = SampleControlledVocab.where(title: 'NFDI4Health Conditions Classification').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['MeSH', 'ICD-10','MedDRA','SNOMED CT',
                                                                                               'Other vocabulary','Free text'])
  )

  #study_ethics_commitee_approval
  study_ethics_commitee_approval_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Ethics Commitee Approval').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Request for approval not yet submitted', 'Request submitted, approval pending',
                                                                                               'Request submitted, approval granted','Request submitted, exempt granted',
                                                                                               'Request submitted, approval denied','Approval not required','Study withdrawn prior to decision on approval',
                                                                                               'Unknown'])
  )

  #study_status_enrolling_by_invitation
  study_status_enrolling_by_invitation_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status Enrolling By Invitation').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No', 'Not applicable'])
  )

  #study_status_when_intervention
  study_status_when_intervention_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status When Intervention').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Intervention ongoing', 'Intervention completed', 'Follow-up ongoing'])
  )

  #study_status_halted_stage
  study_status_halted_stage_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status Halted Stage').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes([
                                                                                                'At the planning stage',
                                                                                                'Ongoing (I): Recruitment ongoing, but data collection not yet started',
                                                                                                'Ongoing (II): Recruitment and data collection ongoing',
                                                                                                'Ongoing (III): Recruitment completed, but data collection ongoing',
                                                                                                'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing'])
  )

  #study_recruitment_status_register
  study_recruitment_status_register_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Recruitment Status Register').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Not yet recruiting', 'Recruiting', 'Enrolling by invitation', 'Active, not recruiting', 'Completed',
                                                                                               'Suspended', 'Terminated', 'Withdrawn', 'Other'])
  )



  #study_type_interventional
  study_type_interventional_cv = SampleControlledVocab.where(title: 'NFDI4Health Interventional Study Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Single Group', 'Parallel','Crossover','Factorial','Sequential','Other','Unknown'])
  )

  #study_type_non_interventional
  study_type_non_interventional_cv = SampleControlledVocab.where(title: 'NFDI4Health Non-interventional Study Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Case-control', 'Case-only','Case-crossover','Ecologic or community studies','Family-based',
                                                                                               'Twin study', 'Cohort',' Birth cohort','Trend', 'Panel',
                                                                                               'Longitudinal','Cross-section', 'Cross-section ad-hoc follow-up', 'Time series',
                                                                                               'Quality control', 'Other','Unknown'])
  )

  #study_primary_purpose
  study_primary_purpose_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Primary Purpose').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Treatment', 'Prevention','Prognostic', 'Diagnostic', 'Supportive Care', 'Screening', 'Health Services Research',
                                                                                               'Basic Science/Physiological study', 'Device Feasibility', 'Pharmacogenetics', 'Pharmacogenomics', 'Health Economics','Other'])
  )



  #study_centers
  study_centers_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Centers').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      %w[Monocentric Multicentric])
  )

  #study_subject
  study_subject_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Subject').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Person',  'Animal', 'Practitioner', 'Device', 'Medication','Substance','Organization','Family',
       'Household','Event/Process','Geographic unit','Time unit','Text unit','Group','Object','Pathogens','Twins',
       'Other','Unknown'])
  )

  #study_status
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

  #study_eligibility_gender
  study_eligibility_gender_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Gender').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Male','Female','Diverse','Not applicable'])
  )

  #study_sampling
  study_sampling_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Sampling').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Total universe/Complete enumeration', 'Probability', 'Probability (Simple random)', 'Probability (Systematic random)', 'Probability (Stratified)',
       'Probability (Stratified: Proportional)','Probability (Stratified: Disproportional)','Probability (Cluster)', 'Probability (Cluster: Simple random)',
       'Probability (Cluster: Stratified random)', 'Probability (Multistage)', 'Non-probability', 'Non-probability (Availability)','Non-probability (Purposive)', 'Non-probability (Quota)',
       'Non-probability (Respondent-assisted)', 'Mixed probability and non-probability', 'Other', 'Unknown','Not applicable'])
  )

  #study_data_source
  study_data_source_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Source').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Blood', 'Buccal cells', 'Cord blood', 'DNA','Faeces', 'Hair','Immortalized cell lines', 'Isolated pathogen', 'Nail', 'Plasma', 'RNA', 'Saliva', 'Serum', 'Tissue (Frozen)', 'Tissue (FFPE)',
       'Urine', 'Other biological samples','Administrative databases', 'Cognitive measurements', 'Genealogical records', 'Imaging data (ultrasound)', 'Imaging data (MRI)', 'Imaging data (MRI, radiography)',
       'Imaging data (CT)', 'Other imaging data', 'Medical records', 'Registries', 'Interview', 'Questionnaire', 'Physiological/Biochemical measurements', 'Genomics', 'Metabolomics', 'Transcriptomics',
       'Proteomics', 'Other omics technology', 'Other'])
  )

  #study_data_sharing_plan_generally
  study_data_sharing_plan_generally_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Sharing Plan Generally').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes, there is a plan to make data available.',
                                                                                                'No, there is no plan to make data available.',
                                                                                                'Undecided, it is not yet known if data will be made available.'])
  )


  #study_data_sharing_plan_supporting_information
  study_data_sharing_plan_supporting_information_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Data Sharing Plan Supporting Information').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Data dictionary', 'Study protocol', 'Protocol amendment', 'Statistical analysis plan',
                                                                                               'Analytic code', 'Informed consent form', 'Clinical study report', 'Manual of operations (SOP)',
                                                                                               'Case report form (template)', 'Questionnaire (template)', 'Code book', 'Other'])
  )

  #study_time_perspective
  study_time_perspective_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Time Perspective').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Retrospective Prospective Cross-sectional Other])
  )

  #study_phase
  study_phase_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Phase').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Early-phase-1','Phase-1','Phase-1-phase-2','Phase-2', 'Phase-2a','Phase-2b',
                                                                                               'Phase-2-phase-3','Phase-3','Phase-3a','Phase-3b','Phase-4','Other','Not applicable'])
  )

  #study_masking
  study_masking_cv =SampleControlledVocab.where(title: 'NFDI4Health Study Masking').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Yes No])
  )

  #study_masking_roles
  study_masking_roles_cv =SampleControlledVocab.where(title: 'NFDI4Health Study Masking Roles').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Participant', 'Care Provider', 'Investigator', 'Outcomes Assessor'])
  )

  #study_allocation
  study_allocation_cv =SampleControlledVocab.where(title: 'NFDI4Health Study Allocation').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Randomized', 'Nonrandomized',' Not applicable (for single-arm trials)'])
  )

  #study_off_label_use
  study_off_label_use_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Off Label Use').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes','No','Not applicable'])
  )

  #study_arm_group_type
  study_arm_group_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Arm Group Type').first_or_create!(
      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Experimental', 'Active Comparator', 'Placebo Comparator',
                                                                                                 'Sham Comparator', 'No Intervention', 'Other'])
    )

  #study_intervention_type
  study_intervention_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Intervention Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Drug (including placebo)','Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery',
                                                                                               'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)',
                                                                                               'Dietary supplement (e.g., vitamins, minerals)',
                                                                                               'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)',
                                                                                               'Diagnostic test (e.g., imaging, in-vitro)', 'Other'])
  )

  #study_outcome_type
  study_outcome_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Outcome Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['Primary',' Secondary','Other'])
  )

  #study_biospecimen_retention
  study_biospecimen_retention_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Biospecimen Retention').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ['None retained','Samples with DNA',' Samples without DNA'])
  )

  #************************ study design related CV end ***********************


  # NFDI4Health Studyhub Resource General
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource General', supported_type: 'StudyhubResource').first_or_create!(

    title: 'NFDI4Health Studyhub Resource General', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'resource_type_general').create!(
        title: 'resource_type_general', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_type_general_cv,
        description: attribute_descriptions['resource_type_general'], label: attribute_headings['resource_type_general']
      ),


      # ******************************** ResourceKeywords Group ***********************
      CustomMetadataAttribute.where(title: 'resource_keywords').create!(
        title: 'resource_keywords', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['resource_keywords'], label: attribute_headings['resource_keywords']
      ),

      CustomMetadataAttribute.where(title: 'resource_keywords_label').create!(
        title: 'resource_keywords_label', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['resource_keywords_label'], label: attribute_headings['resource_keywords_label']
      ),

      CustomMetadataAttribute.where(title: 'resource_keywords_label_code').create!(
        title: 'resource_keywords_label_code', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['resource_keywords_label_code'], label: attribute_headings['resource_keywords_label_code']
      ),
      # ****************************************************************

      CustomMetadataAttribute.where(title: 'resource_language').create!(
        title: 'resource_language', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: resource_language_cv,
        description: attribute_descriptions['resource_language'], label: attribute_headings['resource_language']
      ),

      CustomMetadataAttribute.where(title: 'resource_web_page').create!(
        title: 'resource_web_page', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['resource_web_page'], label: attribute_headings['resource_web_page']
      ),

      CustomMetadataAttribute.where(title: 'resource_version').create!(
        title: 'resource_version', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['resource_version'], label: attribute_headings['resource_version']
      ),


      CustomMetadataAttribute.where(title: 'resource_format').create!(
        title: 'resource_format', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['resource_format'], label: attribute_headings['resource_format']
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_label').create!(
        title: 'resource_use_rights_label', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_label_cv,
        description: attribute_descriptions['resource_use_rights_label'], label: attribute_headings['resource_use_rights_label']
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_description').create!(
        title: 'resource_use_rights_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['resource_use_rights_description'], label: attribute_headings['resource_use_rights_description']
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_authors_confirmation_1').create!(
        title: 'resource_use_rights_authors_confirmation_1', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_authors_confirmation_cv,
        description: attribute_descriptions['resource_use_rights_authors_confirmation_1'],
        label: attribute_headings['resource_use_rights_authors_confirmation_1']
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_authors_confirmation_2').create!(
        title: 'resource_use_rights_authors_confirmation_2', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_authors_confirmation_cv,
        description: attribute_descriptions['resource_use_rights_authors_confirmation_2'],
        label: attribute_headings['resource_use_rights_authors_confirmation_2']
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_authors_confirmation_3').create!(
        title: 'resource_use_rights_authors_confirmation_3', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_authors_confirmation_cv,
        description: attribute_descriptions['resource_use_rights_authors_confirmation_3'],
        label: attribute_headings['resource_use_rights_authors_confirmation_3']
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_support_by_licencing').create!(
        title: 'resource_use_rights_support_by_licencing', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_support_by_licencing_cv,
        description: attribute_descriptions['resource_use_rights_support_by_licencing'],
        label: attribute_headings['resource_use_rights_support_by_licencing']
      )


    ]
  )

  # NFDI4Health Studyhub Resource StudyDesign
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource StudyDesign General', supported_type: 'StudyhubResource').first_or_create!(
    title: 'NFDI4Health Studyhub Resource StudyDesign General', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'study_primary_design').create!(
        title: 'study_primary_design', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_primary_design_cv,
        description: attribute_descriptions['study_primary_design'], label: attribute_headings['study_primary_design']
      ),

      CustomMetadataAttribute.where(title: 'study_type_non_interventional').create!(
        title: 'study_type_non_interventional', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_type_non_interventional_cv,
        description: attribute_descriptions['study_type_non_interventional'], label: attribute_headings['study_type_non_interventional']

      ),

      CustomMetadataAttribute.where(title: 'study_type_interventional').create!(
        title: 'study_type_interventional', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_type_interventional_cv,
        description: attribute_descriptions['study_type_interventional'],label: attribute_headings['study_type_interventional']
      ),

      CustomMetadataAttribute.where(title: 'study_type_description').create!(
        title: 'study_type_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_type_description'], label: attribute_headings['study_type_description']
      ),

      # ****************** StudyDesignConditions ******************
      CustomMetadataAttribute.where(title: 'study_conditions').create!(
        title: 'study_conditions', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_conditions'], label: attribute_headings['study_conditions']
      ),

      CustomMetadataAttribute.where(title: 'study_conditions_classification').create!(
        title: 'study_conditions_classification', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_conditions_classification_cv,
        description: attribute_descriptions['study_conditions_classification'],label: attribute_headings['study_conditions_classification']
      ),

      CustomMetadataAttribute.where(title: 'study_conditions_classification_code').create!(
        title: 'study_conditions_classification_code', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_conditions_classification_code'],label: attribute_headings['study_conditions_classification_code']
      ),
      # ****************************************************************

      CustomMetadataAttribute.where(title: 'study_ethics_commitee_approval').create!(
        title: 'study_ethics_commitee_approval', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_ethics_commitee_approval_cv,
        description: attribute_descriptions['study_ethics_commitee_approval'],label: attribute_headings['study_ethics_commitee_approval']
      ),

      CustomMetadataAttribute.where(title: 'study_status').create!(
        title: 'study_status', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_cv,
        description: attribute_descriptions['study_status'],label: attribute_headings['study_status']
      ),

      CustomMetadataAttribute.where(title: 'study_status_enrolling_by_invitation').create!(
        title: 'study_status_enrolling_by_invitation', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_enrolling_by_invitation_cv,
        description: attribute_descriptions['study_status_enrolling_by_invitation'],label: attribute_headings['study_status_enrolling_by_invitation']
      ),

      CustomMetadataAttribute.where(title: 'study_status_when_intervention').create!(
        title: 'study_status_when_intervention', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_when_intervention_cv,
        description: attribute_descriptions['study_status_when_intervention'], label: attribute_headings['study_status_when_intervention']
      ),

      CustomMetadataAttribute.where(title: 'study_status_halted_stage').create!(
        title: 'study_status_halted_stage', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_halted_stage_cv,
        description: attribute_descriptions['study_status_halted_stage'], label: attribute_headings['study_status_halted_stage']
      ),

      CustomMetadataAttribute.where(title: 'study_status_halted_reason').create!(
        title: 'study_status_halted_reason', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_status_halted_reason'], label: attribute_headings['study_status_halted_reason']
      ),

      CustomMetadataAttribute.where(title: 'study_recruitment_status_register').create!(
        title: 'study_recruitment_status_register', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_recruitment_status_register_cv,
        description: attribute_descriptions['study_recruitment_status_register'],label: attribute_headings['study_recruitment_status_register']
      ),

      CustomMetadataAttribute.where(title: 'study_start_date').create!(
        title: 'study_start_date', required: false, sample_attribute_type: date_type,
        description: attribute_descriptions['study_start_date'],label: attribute_headings['study_start_date']
      ),

      CustomMetadataAttribute.where(title: 'study_end_date').create!(
        title: 'study_end_date', required: false, sample_attribute_type: date_type,
        description: attribute_descriptions['study_end_date'],label: attribute_headings['study_end_date']
      ),

      CustomMetadataAttribute.where(title: 'study_centers').create!(
        title: 'study_centers', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_centers_cv,
        description: attribute_descriptions['study_centers'],label: attribute_headings['study_centers']
      ),

      CustomMetadataAttribute.where(title: 'study_centers_number').create!(
        title: 'study_centers_number', required: false, sample_attribute_type: int_type,
        description: attribute_descriptions['study_centers_number'],label: attribute_headings['study_centers_number']
      ),

      CustomMetadataAttribute.where(title: 'study_subject').create!(
        title: 'study_subject', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_subject_cv,
        description: attribute_descriptions['study_subject'],label: attribute_headings['study_subject']
      ),

      CustomMetadataAttribute.where(title: 'study_sampling').create!(
        title: 'study_sampling', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_sampling_cv,
        description: attribute_descriptions['study_sampling'],label: attribute_headings['study_sampling']
      ),

      CustomMetadataAttribute.where(title: 'study_data_source').create!(
        title: 'study_data_source', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_data_source_cv,
        description: attribute_descriptions['study_data_source'],label: attribute_headings['study_data_source']
      ),

      CustomMetadataAttribute.where(title: 'study_data_source_description').create!(
        title: 'study_data_source_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_data_source_description'], label: attribute_headings['study_data_source_description']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_age_min').create!(
        title: 'study_eligibility_age_min', required: false, sample_attribute_type: float_type,
        description: attribute_descriptions['study_eligibility_age_min'],label: attribute_headings['study_eligibility_age_min']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_age_min_description').create!(
        title: 'study_eligibility_age_min_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_eligibility_age_min_description'],label: attribute_headings['study_eligibility_age_min_description']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_age_max').create!(
        title: 'study_eligibility_age_max', required: false, sample_attribute_type: float_type,
        description: attribute_descriptions['study_eligibility_age_max'],label: attribute_headings['study_eligibility_age_max']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_age_max_description').create!(
        title: 'study_eligibility_age_max_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_eligibility_age_max_description'],label: attribute_headings['study_eligibility_age_max_description']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_gender').create!(
        title: 'study_eligibility_gender', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_eligibility_gender_cv,
        description: attribute_descriptions['study_eligibility_gender'],label: attribute_headings['study_eligibility_gender']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_inclusion_criteria').create!(
        title: 'study_eligibility_inclusion_criteria', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_eligibility_inclusion_criteria'],label: attribute_headings['study_eligibility_inclusion_criteria']
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility_exclusion_criteria').create!(
        title: 'study_eligibility_exclusion_criteria', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_eligibility_exclusion_criteria'],label: attribute_headings['study_eligibility_exclusion_criteria']
      ),

      CustomMetadataAttribute.where(title: 'study_population').create!(
        title: 'study_population', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_population'],label: attribute_headings['study_population']
      ),

      CustomMetadataAttribute.where(title: 'study_target_sample_size').create!(
        title: 'study_target_sample_size', required: false, sample_attribute_type: int_type,
        description: attribute_descriptions['study_target_sample_size'],label: attribute_headings['study_target_sample_size']
      ),

      CustomMetadataAttribute.where(title: 'study_obtained_sample_size').create!(
        title: 'study_obtained_sample_size', required: false, sample_attribute_type: int_type,
        description: attribute_descriptions['study_obtained_sample_size'],label: attribute_headings['study_obtained_sample_size']
      ),

      CustomMetadataAttribute.where(title: 'study_age_min_examined').create!(
        title: 'study_age_min_examined', required: false, sample_attribute_type: float_type,
        description: attribute_descriptions['study_age_min_examined'],label: attribute_headings['study_age_min_examined']
      ),

      CustomMetadataAttribute.where(title: 'study_age_min_examined_description').create!(
        title: 'study_age_min_examined_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_age_min_examined_description'],label: attribute_headings['study_age_min_examined_description']
      ),

      CustomMetadataAttribute.where(title: 'study_age_max_examined').create!(
        title: 'study_age_max_examined', required: false, sample_attribute_type: float_type,
        description: attribute_descriptions['study_age_max_examined'],label: attribute_headings['study_age_max_examined']
      ),

      CustomMetadataAttribute.where(title: 'study_age_max_examined_description').create!(
        title: 'study_age_max_examined_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_age_max_examined_description'],label: attribute_headings['study_age_max_examined_description']
      ),

      CustomMetadataAttribute.where(title: 'study_hypothesis').create!(
        title: 'study_hypothesis', required: false , sample_attribute_type: text_type,
        description: attribute_descriptions['study_hypothesis'],label: attribute_headings['study_hypothesis']
      ),

      # ****************** StudyDesignOutcomes ******************

      CustomMetadataAttribute.where(title: 'outcomes').create!(
        title: 'outcomes', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_design_outcomes'], label: attribute_headings['study_design_outcomes']
      ),


      CustomMetadataAttribute.where(title: 'study_outcome_type').create!(
        title: 'study_outcome_type', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_outcome_type_cv,
        description: attribute_descriptions['study_outcome_type'],label: attribute_headings['study_outcome_type']
      ),

      CustomMetadataAttribute.where(title: 'study_outcome_title').create!(
        title: 'study_outcome_title', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_outcome_title'],label: attribute_headings['study_outcome_title']
      ),

      CustomMetadataAttribute.where(title: 'study_outcome_description').create!(
        title: 'study_outcome_description', required: false , sample_attribute_type: text_type,
        description: attribute_descriptions['study_outcome_description'],label: attribute_headings['study_outcome_description']
      ),

      CustomMetadataAttribute.where(title: 'study_outcome_time_frame').create!(
        title: 'study_outcome_time_frame', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_outcome_time_frame'],label: attribute_headings['study_outcome_time_frame']
      ),

      # ****************** StudyDesignOutcomes ******************

      CustomMetadataAttribute.where(title: 'study_design_comment').create!(
        title: 'study_design_comment', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_design_comment'],label: attribute_headings['study_design_comment']
      ),

      CustomMetadataAttribute.where(title: 'study_data_sharing_plan_generally').create!(
        title: 'study_data_sharing_plan_generally', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_data_sharing_plan_generally_cv,
        description: attribute_descriptions['study_data_sharing_plan_generally'],label: attribute_headings['study_data_sharing_plan_generally']
      ),

      CustomMetadataAttribute.where(title: 'study_data_sharing_plan_description').create!(
        title: 'study_data_sharing_plan_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_data_sharing_plan_description'],label: attribute_headings['study_data_sharing_plan_description']
      ),

      CustomMetadataAttribute.where(title: 'study_data_sharing_plan_supporting_information').create!(
        title: 'study_data_sharing_plan_supporting_information', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_data_sharing_plan_supporting_information_cv,
        description: attribute_descriptions['study_data_sharing_plan_supporting_information'],label: attribute_headings['study_data_sharing_plan_supporting_information']
      ),

      CustomMetadataAttribute.where(title: 'study_data_sharing_plan_time_frame').create!(
        title: 'study_data_sharing_plan_time_frame', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_data_sharing_plan_time_frame'],label: attribute_headings['study_data_sharing_plan_time_frame']
      ),

      CustomMetadataAttribute.where(title: 'study_data_sharing_plan_access_criteria').create!(
        title: 'study_data_sharing_plan_access_criteria', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_data_sharing_plan_access_criteria'],label: attribute_headings['study_data_sharing_plan_access_criteria']
      ),

      CustomMetadataAttribute.where(title: 'study_data_sharing_plan_url').create!(
        title: 'study_data_sharing_plan_url', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_data_sharing_plan_url'],label: attribute_headings['study_data_sharing_plan_url']
      ),

      CustomMetadataAttribute.where(title: 'study_region').create!(
        title: 'study_region', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_region'], label: attribute_headings['study_region']
      )
    ]
  )


  # NFDI4Health Studyhub Resource StudyDesign Non Interventional Study
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource StudyDesign Non Interventional Study', supported_type: 'StudyhubResource').first_or_create!(
    title: 'NFDI4Health Studyhub Resource StudyDesign Non Interventional Study', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [

      #************************ non interventional study design  *******************

      CustomMetadataAttribute.where(title: 'study_time_perspective').create!(
        title: 'study_time_perspective', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_time_perspective_cv,
        description: attribute_descriptions['study_time_perspective'], label: attribute_headings['study_time_perspective']
      ),

      CustomMetadataAttribute.where(title: 'study_target_follow-up_duration').create!(
        title: 'study_target_follow-up_duration', required: false, sample_attribute_type: float_type,
        description: attribute_descriptions['study_target_follow-up_duration'],label: attribute_headings['study_target_follow']
      ),

      CustomMetadataAttribute.where(title: 'study_biospecimen_retention').create!(
        title: 'study_biospecimen_retention', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_biospecimen_retention_cv,
        description: attribute_descriptions['study_biospecimen_retention'],label: attribute_headings['study_biospecimen_retention']
      ),

      CustomMetadataAttribute.where(title: 'study_biospecomen_description').create!(
        title: 'study_biospecomen_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_biospecomen_description'],label: attribute_headings['study_biospecomen_description']
      )

    ]
  )


  # NFDI4Health Studyhub Resource StudyDesign Interventional Study
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource StudyDesign Interventional Study', supported_type: 'StudyhubResource').first_or_create!(
    title: 'NFDI4Health Studyhub Resource StudyDesign Interventional Study', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [

      #************************ interventional study design ***********************


      CustomMetadataAttribute.where(title: 'study_primary_purpose').create!(
        title: 'study_primary_purpose', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_primary_purpose_cv,
        description: attribute_descriptions['study_primary_purpose'],label: attribute_headings['study_primary_purpose']
      ),

      CustomMetadataAttribute.where(title: 'study_phase').create!(
        title: 'study_phase', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_phase_cv,
        description: attribute_descriptions['study_phase'],label: attribute_headings['study_phase']
      ),

      CustomMetadataAttribute.where(title: 'study_masking').create!(
        title: 'study_masking', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_masking_cv,
        description: attribute_descriptions['study_masking'],label: attribute_headings['study_masking']
      ),

      CustomMetadataAttribute.where(title: 'study_masking_roles').create!(
        title: 'study_masking_roles', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_masking_roles_cv,
        description: attribute_descriptions['study_masking_roles'],label: attribute_headings['study_masking_roles']
      ),

      CustomMetadataAttribute.where(title: 'study_masking_description').create!(
        title: 'study_masking_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_masking_description'],label: attribute_headings['study_masking_description']
      ),

      CustomMetadataAttribute.where(title: 'study_allocation').create!(
        title: 'study_allocation', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_allocation_cv,
        description: attribute_descriptions['study_allocation'],label: attribute_headings['study_allocation']
      ),

      CustomMetadataAttribute.where(title: 'study_off_label_use').create!(
        title: 'study_off_label_use', required: false , sample_attribute_type: cv_type, sample_controlled_vocab: study_off_label_use_cv,
        description: attribute_descriptions['study_off_label_use'],label: attribute_headings['study_off_label_use']
      ),

      CustomMetadataAttribute.where(title: 'study_arm_group_label').create!(
        title: 'study_arm_group_label', required: false, sample_attribute_type: string_type,
        description: attribute_descriptions['study_arm_group_label'],label: attribute_headings['study_arm_group_label']
      ),

      CustomMetadataAttribute.where(title: 'study_arm_group_type').create!(
        title: 'study_arm_group_type', required: false, sample_attribute_type: cv_type,sample_controlled_vocab: study_arm_group_type_cv,
        description: attribute_descriptions['study_arm_group_type'],label: attribute_headings['study_arm_group_type']
      ),

      CustomMetadataAttribute.where(title: 'study_arm_group_description').create!(
        title: 'study_arm_group_description', required: false, sample_attribute_type: text_type,
        description: attribute_descriptions['study_arm_group_description'],label: attribute_headings['study_arm_group_description']
      ),

      CustomMetadataAttribute.where(title: 'study_intervention_name').create!(
        title: 'study_intervention_name', required: false , sample_attribute_type: string_type,
        description: attribute_descriptions['study_intervention_name'],label: attribute_headings['study_intervention_name']
      ),

      CustomMetadataAttribute.where(title: 'study_intervention_type').create!(
        title: 'study_intervention_type', required: false, sample_attribute_type: cv_type,sample_controlled_vocab: study_intervention_type_cv,
        description: attribute_descriptions['study_intervention_type'],label: attribute_headings['study_intervention_type']
      ),


      CustomMetadataAttribute.where(title: 'study_intervention_description').create!(
        title: 'study_intervention_description', required: false , sample_attribute_type: text_type,
        description: attribute_descriptions['study_intervention_description'],label: attribute_headings['study_intervention_description']
      ),

      CustomMetadataAttribute.where(title: 'study_intervention_arm_group_label').create!(
        title: 'study_intervention_arm_group_label', required: false , sample_attribute_type: string_type,
        description: attribute_descriptions['study_intervention_arm_group_label'],label: attribute_headings['study_intervention_arm_group_label']
      )
    ]
  )

end
