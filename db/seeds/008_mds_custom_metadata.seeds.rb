puts 'Seeded MDS Metadata Scheme V0.1'

# Initialisation of aliases for common sample attributes types, for easier use.

int_type = SampleAttributeType.find_or_initialize_by(title: 'Integer')
int_type.update(base_type: Seek::Samples::BaseType::INTEGER, placeholder: '1')

bool_type = SampleAttributeType.find_or_initialize_by(title: 'Boolean')
bool_type.update(base_type: Seek::Samples::BaseType::BOOLEAN)

float_type = SampleAttributeType.find_or_initialize_by(title: 'Real number')
float_type.update(base_type: Seek::Samples::BaseType::FLOAT, placeholder: '0.5')

date_type = SampleAttributeType.find_or_initialize_by(title: 'Date')
date_type.update(base_type: Seek::Samples::BaseType::DATE, placeholder: 'January 1, 2022')

string_type = SampleAttributeType.find_or_initialize_by(title: 'String')
string_type.update(base_type: Seek::Samples::BaseType::STRING)

cv_type = SampleAttributeType.find_or_initialize_by(title: 'Controlled Vocabulary')
cv_type.update(base_type: Seek::Samples::BaseType::CV)

text_type = SampleAttributeType.find_or_initialize_by(title: 'Text')
text_type.update(base_type: Seek::Samples::BaseType::TEXT, placeholder: '1')

link_type = SampleAttributeType.find_or_initialize_by(title:'Web link')
link_type.update(base_type: Seek::Samples::BaseType::STRING, regexp: URI.regexp(%w(http https)).to_s, placeholder: 'http://www.example.com', resolution:'\\0')

# helper to create sample controlled vocab
def create_sample_controlled_vocab_terms_attributes(array)
  attributes = []
  array.each do |type|
    attributes << { label: type }
  end
  attributes
end

disable_authorization_checks do

  # seeds for sample controlled vocab

  # study type
  study_type_cv = SampleControlledVocab.where(title: 'Study Type').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Interventional', 'Observational'])
  )

  # study status
  study_status_cv = SampleControlledVocab.where(title: 'Study Status').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Running', 'Closed'])
  )

  # study accrual
  study_accrual_cv = SampleControlledVocab.where(title: 'Study Accrual').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No'])
  )

  # study status
  study_dmp_cv = SampleControlledVocab.where(title: 'Study DMP').first_or_create!(
    sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(['Yes', 'No', 'On request'])
  )

  # Definition of the Custom Metadata types

  # Helper
  def create_custom_metadata_attribute(title:, required:, sample_attribute_type:, sample_controlled_vocab: nil)
    CustomMetadataAttribute.where(title).create!(title: title, required: required,
                                                 sample_attribute_type: sample_attribute_type,
                                                 sample_controlled_vocab: sample_controlled_vocab)
  end

  # ISA Study

  CustomMetadataType.where(title: 'MDS Metadata V0.1 for object type Study', supported_type: 'Study').first_or_create!(
    title: 'MDS Metadata V0.1 for object type Study', supported_type: 'Study',
    custom_metadata_attributes: [
      create_custom_metadata_attribute(title: 'Study Acronym', required: false, sample_attribute_type: string_type),
      create_custom_metadata_attribute(title: 'Study Identifier', required: false, sample_attribute_type: string_type),
      create_custom_metadata_attribute(title: 'Study Start Date', required: false, sample_attribute_type: date_type),
      create_custom_metadata_attribute(title: 'Study End Date', required: false, sample_attribute_type: date_type),
      create_custom_metadata_attribute(title: 'Study Homepage', required: false, sample_attribute_type: link_type),
      create_custom_metadata_attribute(title: 'Study Type', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_type_cv),
      create_custom_metadata_attribute(title: 'Health Condition(s) or Problem(s) Studied', required: false, sample_attribute_type: text_type),
      create_custom_metadata_attribute(title: 'Sample Size', required: false, sample_attribute_type: int_type),
      create_custom_metadata_attribute(title: 'Study Status', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_status_cv),
      create_custom_metadata_attribute(title: 'Number of sites', required: false, sample_attribute_type: int_type),
      create_custom_metadata_attribute(title: 'Recruting?', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_accrual_cv),
      create_custom_metadata_attribute(title: 'Data Management Plan for data sharing?', required: false, sample_attribute_type: cv_type, sample_controlled_vocab: study_dmp_cv)
    ]
  )

end

