puts 'Seeded Studyhub Resource Types'
ActiveRecord::FixtureSet.create_fixtures(File.join(Rails.root, 'config/default_data'), 'studyhub_resource_types')

puts 'Seeded NFDI4Health Studyhub Resource Metadata'

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
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Audiovisual Collection DataPaper Dataset Event Image InteractiveResource
Model PhysicalObject Service Software Sound Text Workflow Other])
  )


  # resource_language
  resource_language_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Language').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[EN DE FR ES])
  )

  #resource_use_rights_label
  resource_use_rights_label_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Use Rights Label').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(["CC0",
                                                                                               "CC BY 4.0", "CC BY-NC 4.0", "CC BY-ND 4.0", "CC BY-SA 4.0", "CC BY-NC-SA 4.0", "CC BY-NC-ND 4.0", "All rights reserved", "Other", "N/A", "Unknown"])
  )

  #resource_use_rights_authors_confirmation_cv
  resource_use_rights_authors_confirmation_cv = SampleControlledVocab.where(title: 'NFDI4Health Resource Use Rights Author Confirmation').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(["Yes", "No" ]))

  # id_type
  id_type_cv = SampleControlledVocab.where(title: 'NFDI4Health ID Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[arXiv bibcode DOI EAN13 EISSN ISBN ISSN ISTC LISSN LSID NFDI4Health PMID PURL URL URN w3id ORCID ISNI ROR GRID DRKS ISRCTN EudraCT NCT(clinicaltrials.gov) Other])

  )

  # id_resource_type_general
  id_resource_type_general_cv = SampleControlledVocab.where(title: 'NFDI4Health ID Resource Type General').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[Audiovisual Book BookChapter Collection
ComputationalNotebook ConferencePaper ConferenceProceeding DataPaper Dataset Dissertation Event Image InteractiveResource Journal JournalArticle Model
OutputManagementPlan PeerReview PhysicalObject Preprint ReportService Software Sound Standard Text Workflow Other])
  )

  # id_relation_type
  id_relation_types_cv = SampleControlledVocab.where(title: 'NFDI4Health ID Relation Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[IsCitedBy Cites IsSupplementTo IsSupplementedBy IsContinuedBy Continues
IsDescribedBy Describes HasMetadata IsMetadataFor HasVersion IsVersionOf IsNewVersionOf IsPreviousVersionOf IsPartOf HasPart IsReferencedBy References IsDocumentedBy Documents
IsCompiledBy Compiles IsVariantFormOf IsOriginalFormOf IsIdenticalTo IsReviewedBy Reviews IsDerivedFrom IsSourceOf IsRequiredBy Requires IsObsoletedBy Obsoletes])
  )

  # role_type
  role_type_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(["Author","Principal Investigator", "Contributor", "ContactPerson", "DataCollector", "DataCurator",
                                                                                               "DataManager", "Distributor","Editor", "HostingInstitution", "Producer", "ProjectLeader/Principal Investigator", "ProjectManager",
                                                                                               "ProjectMember", "RegistrationAgency", "RegistrationAuthority", "RelatedPerson", "Researcher", "ResearchGroup", "RightsHolder",
                                                                                               "Supervisor", "WorkPackageLeader", "Primary sponsor", "Secondary Sponsor", "Sponsor-Investigator", "Sponsor", "Funder",
                                                                                               "Public funder","Private funder", "Publisher", "Other"]))


  # # role_specific_type
  # role_specific_type_sponsor_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Specific Type Sponsor').first_or_create!(
  #   sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[primary secondary])
  # )
  #
  # role_specific_type_funder_cv = SampleControlledVocab.where(title: 'NFDI4Health Role Specific Type Funder').first_or_create!(
  #   sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[public private])
  # )

  #study_primary_design
  study_primary_design_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Primary Design').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(%w[non-interventional interventional])
  )

  #study_type_interventional
  study_type_interventional_cv = SampleControlledVocab.where(title: 'NFDI4Health Interventional Study Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Single Group', 'Parallel','Crossover','Factorial','Sequential','Other'])
  )

  #study_type_non_interventional
  study_type_non_interventional_cv = SampleControlledVocab.where(title: 'NFDI4Health Non-interventional Study Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Case-Control', 'Case-Only','Case-Crossover','Cohort',' Birth cohort','Cross-section',
                                                                                               'Cross-section ad-hoc follow-up', 'Ecologic or Community Studies',
                                                                                               'Family-Based','Longitudinal', 'Panel', 'Quality control', 'Time series','Trend',
                                                                                               'Twin-study','Other'])
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
      ['Individual', 'Organization', 'Family', 'Household', 'Event/Process', 'Geographic Unit',
       'Time Unit', 'Text Unit', 'Group', 'Object', 'Pathogens', 'Twins', 'Other'])
  )

  #study_status
  study_status_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Status').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ["Not yet recruiting", "Recruiting", "Enrolling by invitation", "Active,not recruiting",
       "Completed","Suspended", "Terminated", "Withdrawn"])
  )

  #study_sex
  study_sex_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Sex').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      %w[Male Female All])
  )

  #study_sampling
  study_sampling_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Sampling').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      [
        "TotalUniverseCompleteEnumeration", "Probability", "Probability.SimpleRandom, Probability.SystematicRandom",
        "Probability.Stratified, Probability.Stratified.Proportional", "Probability.Stratified.Disproportional",
        "Probability.Cluster", "Probability.Cluster.SimpleRandom", "Probability.Cluster.StratifiedRandom", "Probability.Multistage",
        "Nonprobability", "Nonprobability.Availability", "Nonprobability.Purposive", "Nonprobability.Quota", "Nonprobability.RespondentAssisted",
        "MixedProbabilityNonprobability", "Other"
      ])
  )

  #study_datasource
  study_datasource_cv = SampleControlledVocab.where(title: 'NFDI4Health Study Datasource').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
      ["Blood", "Buccal cells", "Cord blood", "DNA","Faeces", "Hair","Immortalized Cell Lines",
       "Isolated Pathogen", "Nail", "Plasma", "RNA", "Saliva", "Serum", "Tissue (Frozen)", "Tissue (FFPE)",
       "Urine", "Other Biological samples","Administrative databases", "Cognitive measurements", "Genealogical records",
       "Imaging data", "Medical records", "Registries", "Survey data", "Physiological/Biochemical measurements",
       "Genomics", "Metabolomics", "Transcriptomics", "Proteomics", "Other Omics Technology", "Other"])
  )

  #study_IPD_sharing_plan_generally
  study_IPD_sharing_plan_generally_cv = SampleControlledVocab.where(title: 'NFDI4Health Study IPD Sharing Plan Generally').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(["Yes: There is a plan to make IPD and related data dictionaries available.",
                                                                                               "No: There is not a plan to make IPD available.","Undecided: It is not yet known if there will be a plan to make IPD available."])
  )





  # NFDI4Health Studyhub Resource General
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource General', supported_type: 'StudyhubResource').first_or_create!(

    title: 'NFDI4Health Studyhub Resource General', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'resource_type_general').create!(
        title: 'resource_type_general', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_type_general_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_language').create!(
        title: 'resource_language', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: resource_language_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_version').create!(
        title: 'resource_version', required: false, sample_attribute_type: string_type
      ),


      CustomMetadataAttribute.where(title: 'resource_format').create!(
        title: 'resource_format', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_label').create!(
        title: 'resource_use_rights_label', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_label_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_description').create!(
        title: 'resource_use_rights_description', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_authors_confirmation_1').create!(
        title: 'resource_use_rights_authors_confirmation_1', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_authors_confirmation_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_authors_confirmation_2').create!(
        title: 'resource_use_rights_authors_confirmation_2', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_authors_confirmation_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_use_rights_authors_confirmation_3').create!(
        title: 'resource_use_rights_authors_confirmation_3', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: resource_use_rights_authors_confirmation_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_web_page').create!(
        title: 'resource_web_page', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'acronym').create!(
        title: 'acronym', required: false, sample_attribute_type: string_type
      )
    ]
  )

  # NFDI4Health Studyhub Resource StudyDesign
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource StudyDesign', supported_type: 'StudyhubResource').first_or_create!(
    title: 'NFDI4Health Studyhub Resource StudyDesign', supported_type: 'StudyhubResource',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'study_primary_design').create!(
        title: 'study_primary_design', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_primary_design_cv
      ),

      CustomMetadataAttribute.where(title: 'study_type_interventional').create!(
        title: 'study_type_interventional', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_type_interventional_cv
      ),

      CustomMetadataAttribute.where(title: 'study_type_non_interventional').create!(
        title: 'study_type_non_interventional', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_type_non_interventional_cv
      ),

      CustomMetadataAttribute.where(title: 'study_type_description').create!(
        title: 'study_type_description', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_primary_purpose').create!(
        title: 'study_primary_purpose', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_primary_purpose_cv
      ),

      CustomMetadataAttribute.where(title: 'study_conditions').create!(
        title: 'study_conditions', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_conditions_code').create!(
        title: 'study_conditions_code', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_keywords').create!(
        title: 'study_keywords', required: false, sample_attribute_type: string_type
    ),


      CustomMetadataAttribute.where(title: 'study_centers').create!(
        title: 'study_centers', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_centers_cv
      ),


      CustomMetadataAttribute.where(title: 'study_subject').create!(
        title: 'study_subject', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_subject_cv
      ),

      CustomMetadataAttribute.where(title: 'study_status').create!(
        title: 'study_status', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_cv
      ),


      CustomMetadataAttribute.where(title: 'study_region').create!(
        title: 'study_region', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_target_sample_size').create!(
        title: 'study_target_sample_size', required: false, sample_attribute_type: int_type
      ),

      CustomMetadataAttribute.where(title: 'study_obtained_sample_size').create!(
        title: 'study_obtained_sample_size', required: false, sample_attribute_type: int_type
      ),

      CustomMetadataAttribute.where(title: 'study_age_min').create!(
        title: 'study_age_min', required: false, sample_attribute_type: float_type
      ),

      CustomMetadataAttribute.where(title: 'study_age_max').create!(
        title: 'study_age_max', required: false, sample_attribute_type: float_type
      ),

      CustomMetadataAttribute.where(title: 'study_sex').create!(
        title: 'study_sex', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_sex_cv
      ),

      CustomMetadataAttribute.where(title: 'study_inclusion_criteria').create!(
        title: 'study_inclusion_criteria', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_exclusion_criteria').create!(
        title: 'study_exclusion_criteria', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_population').create!(
        title: 'study_population', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_sampling').create!(
        title: 'study_sampling', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_sampling_cv
      ),

      CustomMetadataAttribute.where(title: 'study_start_date').create!(
        title: 'study_start_date', required: false, sample_attribute_type: date_type
      ),

      CustomMetadataAttribute.where(title: 'study_end_date').create!(
        title: 'study_end_date', required: false, sample_attribute_type: date_type
      ),

      CustomMetadataAttribute.where(title: 'study_datasource').create!(
        title: 'study_datasource', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_datasource_cv
      ),

      CustomMetadataAttribute.where(title: 'study_hypothesis').create!(
        title: 'study_hypothesis', required: false , sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_design_comment').create!(
        title: 'study_design_comment', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_IPD_sharing_plan_generally').create!(
        title: 'study_IPD_sharing_plan_generally', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: study_IPD_sharing_plan_generally_cv
      ),

      CustomMetadataAttribute.where(title: 'study_IPD_sharing_plan_description').create!(
        title: 'study_IPD_sharing_plan_description', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_IPD_sharing_plan_time_frame').create!(
        title: 'study_IPD_sharing_plan_time_frame', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_IPD_sharing_plan_access_criteria').create!(
        title: 'study_IPD_sharing_plan_access_criteria', required: false, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_IPD_sharing_plan_url').create!(
        title: 'study_IPD_sharing_plan_url', required: false, sample_attribute_type: string_type
      )

    ]
  )

end
