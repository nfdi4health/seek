class StudyhubResource < ApplicationRecord

  belongs_to :studyhub_resource_type, inverse_of: :studyhub_resources

  has_one :content_blob,:as => :asset, :foreign_key => :asset_id

  has_filter studyhub_resource_type: Seek::Filtering::Filter.new(
    value_field: 'studyhub_resource_types.key',
    label_field: 'studyhub_resource_types.title',
    joins: [:studyhub_resource_type]
  )

  has_extended_custom_metadata
  acts_as_asset

  validates :resource_json, presence: true, on: %i[create update], unless: :is_ui_request?
  validates :resource_json, resource_json:true, on:  %i[create update], unless: :is_ui_request?
  validate :check_resource_use_rights, on:  [:create, :update], unless: :is_ui_request?
  validate :check_urls, on:  [:create, :update]
  validate :end_date_is_after_start_date, on: [:create, :update], if: :is_studytype?


  validate :check_nfdi_resource_id, on: [:create, :update]


  attr_readonly :studyhub_resource_type_id
  attr_accessor :commit_button
  attr_accessor :ui_request

  before_save :save_stage, on:  [:create, :update]
  before_save :covert_to_mds_date_format, on:  [:create, :update], if: :is_ui_request?
  before_validation :set_resource_titles_to_title
  after_validation :convert_label_to_id_for_multi_select_attribute, unless: :is_ui_request?


  # *****************************************************************************
  #  This section defines constants for "mandatory fields" values
  #
  REQUIRED_FIELDS_RESOURCE_BASIC = %w[resource_type_general resource_use_rights_label].freeze
  REQUIRED_FIELDS_STUDY_DESIGN_GENERAL = ['study_primary_design','study_type', 'study_status','study_data_sharing_plan_generally','study_country','study_subject'].freeze
  INTERVENTIONAL = 'Interventional'.freeze
  NON_INTERVENTIONAL = 'Non-interventional'.freeze
  URL_FIELDS = %w[resource_web_page study_data_sharing_plan_url].freeze
  RESOURCE_KEYWORDS = 'resource_keywords'.freeze
  ID_TYPE = %w[name affiliation].freeze
  DATE_TYPE = %w[study_start_date study_end_date].freeze

  # *****************************************************************************
  #  This section defines constants for "working stages" values
  SAVED = 0
  SUBMITTED  = 1


  # *****************************************************************************
  #  This section defines constants for boolean attributes
  BOOLEAN_ATTRIBUTES_HASH = {'resource' => %w[resource_use_rights_authors_confirmation_1 resource_use_rights_authors_confirmation_2 resource_use_rights_authors_confirmation_3 resource_use_rights_support_by_licencing],
                                 'study_design' => %w[study_masking] }.freeze


  # *****************************************************************************
  #  This section defines constants for multiselect attributes
  MULTISELECT_ATTRIBUTES_HASH = {'resource' => %w[resource_language],
                                 'study_design' => %w[study_data_source study_country study_data_sharing_plan_supporting_information study_eligibility_gender],
                                 'interventional_study_design' => %w[study_masking_roles],
                                 'non_interventional_study_design' => %w[study_time_perspective study_biospecimen_retention]}.freeze


  MULTISELECT_ATTRIBUTES_HASH_2_1 = {'resource' => %w[resource_languages],
                                 'study_design' => %w[study_countries],
                                 'study_data_source' => %w[study_data_sources_general study_data_sources_biosamples study_data_sources_imaging study_data_sources_omics],
                                 'study_eligibility_criteria' => %w[study_eligibility_genders],
                                 'study_data_sharing_plan' => %w[study_data_sharing_plan_supporting_information],
                                 'study_masking' => %w[study_masking_roles],
                                 'study_design_non_interventional' => %w[study_time_perspectives study_biospecimen_retention]}.freeze


  # *****************************************************************************
  #  This section defines attributes which have 0-n relationship
  MULTI_ATTRIBUTE_FIELDS_LIST_STYLE =  { 'study_conditions' => %w[study_conditions study_conditions_classification study_conditions_classification_code],
                                         'study_outcomes' => %w[study_outcome_type study_outcome_title
                                                                study_outcome_description study_outcome_time_frame],
                                         'interventional_study_design_arms' => %w[study_arm_group_label
                                                                                  study_arm_group_type study_arm_group_description],
                                         'interventional_study_design_interventions' => %w[study_intervention_name
                                                                                           study_intervention_type study_intervention_description study_intervention_arm_group_label]

  }.freeze

  MULTI_ATTRIBUTE_FIELDS_ROW_STYLE =  { 'resource_keywords' => %w[resource_keywords_label resource_keywords_label_code]
  }.freeze

  MULTI_ATTRIBUTE_SKIPPED_FIELDS = %w[resource_keywords_label resource_keywords_label_code study_conditions_classification study_conditions_classification_code
                                      study_outcome_type study_outcome_title study_outcome_description study_outcome_time_frame
                                      study_arm_group_label study_arm_group_type study_arm_group_description
                                      study_intervention_name study_intervention_type study_intervention_description study_intervention_arm_group_label study_recruitment_status_register].freeze

  NOT_PUBLIC_DISPLAY_ATTRIBUTES =  %w[study_recruitment_status_register].freeze

  def description
    if resource_json['resource_descriptions'].blank?
      'No description specified'
    else
      resource_json['resource_descriptions'].first['description']
    end
  end

  def check_resource_use_rights

    return unless is_ui_request? || errors.messages.blank?
    return if is_studytype?

    if resource_json['resource_non_study_details'].key?('resource_use_rights')
      resource_use_rights = resource_json['resource_non_study_details']['resource_use_rights']
      if ['CC BY 4.0 (Creative Commons Attribution 4.0 International)',
          'CC BY-NC 4.0 (Creative Commons Attribution Non Commercial 4.0 International)',
          'CC BY-SA 4.0 (Creative Commons Attribution Share Alike 4.0 International)',
          'CC BY-NC-SA 4.0 (Creative Commons Attribution Non Commercial Share Alike 4.0 International)'].include? resource_use_rights['resource_use_rights_label']
        errors.add('resource_use_rights_confirmations'.to_sym, 'The attribute is needed.') unless resource_use_rights.key? 'resource_use_rights_confirmations'
      end
    end
  end

  def check_urls

    return unless is_ui_request?  || errors.messages.blank?

    unless validate_url(resource_json['resource_web_page'])
      errors.add('resource_web_page'.to_sym, 'is not a url.')
    end

    resource_json['roles']&.each_with_index do |role,index_1|
      role_affiliations = role['role_affiliations']
      role_affiliations&.each_with_index do |affiliations,index_2|
        unless validate_url(affiliations['role_affiliation_web_page'])
          errors.add("roles[#{index_1}]['role_affiliations'][#{index_2}]['role_affiliation_web_page']".to_sym, 'is not a url.')
        end
      end
    end

    if is_studytype?
      return unless resource_json['study_design']['study_data_sharing_plan'].key? 'study_data_sharing_plan_url'
      unless validate_url(resource_json['study_design']['study_data_sharing_plan']['study_data_sharing_plan_url'])
        errors.add('study_data_sharing_plan_url'.to_sym, 'is not a url.')
      end
    end

  end

  def end_date_is_after_start_date
    return unless is_ui_request?  || errors.messages.blank?

    start_date = resource_json['study_design']['study_start_date']
    end_date = resource_json['study_design']['study_end_date']

    return if end_date.blank? || start_date.blank?

    unless is_ui_request?
      start_date = Date.parse(start_date).strftime('%Y-%m-%d') unless start_date.blank?
      end_date = Date.parse(end_date).strftime('%Y-%m-%d') unless start_date.blank?
    end

    errors.add(:study_end_date, 'cannot be before the start date') if end_date < start_date
  end

  def check_nfdi_resource_id
    return unless errors[:resource_json].blank?

    resource_json['ids_nfdi4health']&.each_with_index do |id,index|
        begin
          a = Integer(id['identifier'])
        rescue ArgumentError, TypeError
          errors.add("ids_nfdi4health[#{index}]['identifier']".to_sym, 'The value must be the ID of the NFDI4Health resource. e.g.1')
        end
        begin
        end
        if StudyhubResource.where(id: id['identifier']).blank?
          errors.add("ids_nfdi4health[#{index}]['identifier']".to_sym, "This NFDI4Health resource ID doesn't exist.")
        end
    end
  end

  def final_error_check
    unless errors.messages.except(:resource_json).empty?
      errors.add(:base, 'Please make sure all required fields are filled in correctly.')
    end
  end

  def request_to_submit?
    commit_button == 'Submit'
  end

  def is_ui_request?
    ui_request.nil?? false : true
  end

  def is_submitted?
    stage == StudyhubResource::SUBMITTED
  end

  def studyhub_resource_type_title
    StudyhubResourceType.find(studyhub_resource_type_id).title.downcase
  end

  def save_stage
    self.stage = if request_to_submit?
                   StudyhubResource::SUBMITTED
                 else
                   StudyhubResource::SAVED
                 end

  end

  # if the resource type is study or non_study
  def is_studytype?
    studyhub_resource_type.is_studytype?
  end

  def is_interventional_study?
     get_study_primary_design_type == 'Interventional'
  end

  def is_non_interventional_study?
    get_study_primary_design_type == 'Non-interventional'
  end

  # if the resource type is study or substudy
  def get_study_primary_design_type
    return nil unless is_studytype?
    resource_json['study_design']['study_primary_design']
  end

  def set_resource_titles_to_title
    self.title = resource_json['resource_titles']&.first.blank?? nil : resource_json['resource_titles']&.first['text']
  end

  def covert_to_mds_date_format

    resource_json['ids']&.each_with_index do |id,index|
      resource_json['ids'][index]['id_date'] = convert_date_format(id['id_date']) unless id['id_date'].blank?
    end

    if is_studytype?
      StudyhubResource::DATE_TYPE.each do |attr|
        resource_json['study_design'][attr] = convert_date_format(resource_json['study_design'][attr]) unless resource_json['study_design'][attr].blank?
      end
    end
  end

  def convert_date_format(date)
    Date.parse(date).strftime('%d.%m.%Y')
  end

  def convert_label_to_id_for_multi_select_attribute

    return unless errors.messages[:resource_json].empty?

    StudyhubResource::MULTISELECT_ATTRIBUTES_HASH_2_1.keys.each do |key|
      StudyhubResource::MULTISELECT_ATTRIBUTES_HASH_2_1[key].each do |attr|
        if key == 'resource'
          self.resource_json[attr] = covert_label_to_id(self.resource_json[attr]) unless resource_json[attr].blank?
        end


        next unless is_studytype?

        study_design = self.resource_json['study_design']

        unless study_design[attr].blank?
          study_design[attr] =
            covert_label_to_id(study_design[attr])
        end

        if key == 'study_data_source'
          unless study_design['study_data_source'].blank? || study_design['study_data_source'][attr].blank?
            study_design['study_data_source'][attr] =
              covert_label_to_id(study_design['study_data_source'][attr])
          end
        end

        if key == 'study_eligibility_criteria'
          unless study_design['study_eligibility_criteria'].blank? || study_design['study_eligibility_criteria'][attr].blank?
            study_design['study_eligibility_criteria'][attr] =
              covert_label_to_id(study_design['study_eligibility_criteria'][attr])
          end
        end

        if key == 'study_data_sharing_plan'
          unless study_design['study_data_sharing_plan'][attr].blank?
            study_design['study_data_sharing_plan'][attr] =
              covert_label_to_id(study_design['study_data_sharing_plan'][attr])
          end
        end

        if is_non_interventional_study? && key == 'study_design_non_interventional'
          unless study_design['study_design_non_interventional'].blank? || study_design['study_design_non_interventional'][attr].blank?
            study_design['study_design_non_interventional'][attr] =
              covert_label_to_id(study_design['study_design_non_interventional'][attr])

          end
        end

        next unless is_interventional_study? && key == 'study_masking' && study_design.key?('study_design_interventional') && study_design['study_design_interventional'].key?('study_masking')
        unless study_design['study_design_interventional']['study_masking'][attr].blank?
          study_design['study_design_interventional']['study_masking'][attr]= covert_label_to_id(study_design['study_design_interventional']['study_masking'][attr])
        end
      end
    end
  end

  private

  def covert_label_to_id(labels)
    ids = labels.map {|label| SampleControlledVocabTerm.where(label: label).first.try(:id).to_s}
    ids
  end

  def is_integer?
    to_i.to_s == self
  end

  # https://newbedev.com/how-to-check-if-a-url-is-valid
  def validate_url(url)

    return true if url.blank?

    begin
      uri = URI.parse(url.strip)
      resp = uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
    rescue URI::InvalidURIError
      resp = false
    end
  end

end
