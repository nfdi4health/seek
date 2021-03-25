int_type = SampleAttributeType.find_or_initialize_by(title:'Integer')
int_type.update_attributes(base_type: Seek::Samples::BaseType::INTEGER, placeholder: '1')

date_type = SampleAttributeType.find_or_initialize_by(title:'Date')
date_type.update_attributes(base_type: Seek::Samples::BaseType::DATE, placeholder: 'January 1, 2015')

string_type = SampleAttributeType.find_or_initialize_by(title:'String')
string_type.update_attributes(base_type: Seek::Samples::BaseType::STRING)

cv_type = SampleAttributeType.find_or_initialize_by(title:'Controlled Vocabulary')
cv_type.update_attributes(base_type: Seek::Samples::BaseType::CV)

disable_authorization_checks do

  # Studyhub resource type controlled vocabs
  resource_type_cv = SampleControlledVocab.where(title: 'NFDI4Health resource type').first_or_create!(
    sample_controlled_vocab_terms_attributes: [{ label: 'Study' }, { label: 'Substudy' }, { label: 'Instrument' },
                                               { label: 'Document' }]
  )

  # NFDI4Health Studyhub Study Metadata (resource_type: study and substudy)
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Study Metadata').first_or_create!(
    title: 'NFDI4Health Studyhub Study Metadata', supported_type: 'Study',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'resource_id').create!(
        title: 'resource_id', required: true, sample_attribute_type: int_type
      ),

      CustomMetadataAttribute.where(title: 'resource_web_studyhub').create!(
        title: 'resource_web_studyhub', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'resource_web_page').create!(
        title: 'resource_web_page', required: true, sample_attribute_type: string_type
      ),
      CustomMetadataAttribute.where(title: 'resource_type').create!(
        title: 'resource_type', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_type_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_web_mica').create!(
        title: 'resource_web_mica', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'acronym').create!(
        title: 'acronym', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_type').create!(
        title: 'study_type', required: true, sample_attribute_type: string_type
      ),


      CustomMetadataAttribute.where(title: 'study_start_date').create!(
        title: 'study_start_date', required: true, sample_attribute_type: date_type
      ),

      CustomMetadataAttribute.where(title: 'study_end_date').create!(
        title: 'study_end_date', required: true, sample_attribute_type: date_type
      ),


      CustomMetadataAttribute.where(title: 'study_status').create!(
        title: 'study_status', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_country').create!(
        title: 'study_country', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility').create!(
        title: 'study_eligibility', required: true, sample_attribute_type: string_type
      )

    ]
  )


  # NFDI4Health Studyhub Resource Metadata (resource_type: except study and substudy)
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata').first_or_create!(
    title: 'NFDI4Health Studyhub Resource Metadata', supported_type: 'Assay',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'resource_id').create!(
        title: 'resource_id', required: true, sample_attribute_type: int_type
      ),

      CustomMetadataAttribute.where(title: 'resource_web_studyhub').create!(
        title: 'resource_web_studyhub', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'resource_web_page').create!(
        title: 'resource_web_page', required: true, sample_attribute_type: string_type
      ),
      CustomMetadataAttribute.where(title: 'resource_type').create!(
        title: 'resource_type', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_type_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_web_mica').create!(
        title: 'resource_web_mica', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'acronym').create!(
        title: 'acronym', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_type').create!(
        title: 'study_type', required: true, sample_attribute_type: string_type
      ),


      CustomMetadataAttribute.where(title: 'study_start_date').create!(
        title: 'study_start_date', required: true, sample_attribute_type: date_type
      ),

      CustomMetadataAttribute.where(title: 'study_end_date').create!(
        title: 'study_end_date', required: true, sample_attribute_type: date_type
      ),


      CustomMetadataAttribute.where(title: 'study_status').create!(
        title: 'study_status', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_country').create!(
        title: 'study_country', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_eligibility').create!(
        title: 'study_eligibility', required: true, sample_attribute_type: string_type
      )
    ]
  )
end
