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

  # NFDI4Health Studyhub Study Metadata
  CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata').first_or_create!(
    title: 'NFDI4Health Studyhub Resource Metadata', supported_type: 'Study',
    custom_metadata_attributes: [

      CustomMetadataAttribute.where(title: 'resource_id').first_or_create!(
        title: 'resource_id', required: true, sample_attribute_type: int_type
      ),

      CustomMetadataAttribute.where(title: 'resource_web_studyhub').first_or_create!(
        title: 'resource_web_studyhub', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'resource_web_page').first_or_create!(
        title: 'resource_web_page', required: true, sample_attribute_type: string_type
      ),
      CustomMetadataAttribute.where(title: 'resource_type').first_or_create!(
        title: 'resource_type', required: true, sample_attribute_type: cv_type, sample_controlled_vocab: resource_type_cv
      ),

      CustomMetadataAttribute.where(title: 'resource_web_mica').first_or_create!(
        title: 'resource_web_mica', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'acronym').first_or_create!(
        title: 'acronym', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_type').first_or_create!(
        title: 'study_type', required: true, sample_attribute_type: string_type
      ),


      CustomMetadataAttribute.where(title: 'study_start_date').first_or_create!(
        title: 'study_start_date', required: true, sample_attribute_type: date_type
      ),

      CustomMetadataAttribute.where(title: 'study_end_date').first_or_create!(
        title: 'study_end_date', required: true, sample_attribute_type: date_type
      ),


      CustomMetadataAttribute.where(title: 'study_status').first_or_create!(
        title: 'study_status', required: true, sample_attribute_type: string_type
      ),

      CustomMetadataAttribute.where(title: 'study_country').first_or_create!(
        title: 'study_country', required: true, sample_attribute_type: string_type
      ),
      CustomMetadataAttribute.where(title: 'study_eligibility').first_or_create!(
        title: 'study_eligibility', required: true, sample_attribute_type: string_type
      )
    ]
  )
end
