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
  validate :check_title_presence, on:  [:create, :update]
  validate :check_urls, on:  [:create, :update]
  validate :check_provenance_data_presence, on:  [:create, :update]
  validate :check_numericality, on:  [:create, :update], if: :is_studytype?
  validate :end_date_is_after_start_date, on: [:create, :update], if: :is_studytype?
  validate :check_mandatory_resource_use_rights, on:  [:create, :update], if: :request_to_submit?
  validate :check_id_presence, on: [:create, :update], if: :request_to_submit?
  validate :check_role_presence, on: [:create, :update], if: :request_to_submit?
  validate :check_description_presence, on:  [:create, :update], if: :request_to_submit?
  validate :check_required_singular_attributes, on:  [:create, :update], if: :request_to_submit?
  validate :check_required_multi_attributes, on:  [:create, :update], if: -> {request_to_submit? && is_studytype?}
  validate :check_nfdi_resource_id, on: [:create, :update]


  validate :final_error_check, on:  [:create, :update], if: :is_ui_request?

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
  REQUIRED_FIELDS_RESOURCE_USE_RIGHTS = %w[resource_use_rights_authors_confirmation_1 resource_use_rights_authors_confirmation_2 resource_use_rights_authors_confirmation_3 resource_use_rights_support_by_licencing].freeze
  REQUIRED_FIELDS_STUDY_DESIGN_GENERAL = ['study_primary_design','study_type', 'study_status','study_data_sharing_plan_generally','study_country','study_subject'].freeze
  INTERVENTIONAL = 'Interventional'.freeze
  NON_INTERVENTIONAL = 'Non-interventional'.freeze
  URL_FIELDS = %w[resource_web_page study_data_sharing_plan_url].freeze
  RESOURCE_KEYWORDS = 'resource_keywords'.freeze
  ID_TYPE = %w[name affiliation].freeze
  DATE_TYPE = %w[study_start_date study_end_date].freeze
  IRI_TYPE = %w[resource_keywords_label_code study_conditions_classification_code].freeze

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

  INTEGER_ATTRIBUTES =  %w[study_centers_number study_target_sample_size study_obtained_sample_size].freeze
  FLOAT_ATTRIBUTES =  %w[study_eligibility_age_min study_eligibility_age_max study_age_min_examined
study_age_max_examined study_target_follow-up_duration].freeze


  def description
    if resource_json['resource_descriptions'].blank?
      'No description specified'
    else
      resource_json['resource_descriptions'].first['description']
    end
  end

  def check_mandatory_resource_use_rights
    if resource_json['resource_use_rights_label']&.start_with?('CC')
      REQUIRED_FIELDS_RESOURCE_USE_RIGHTS.each do |name|
        errors.add(name.to_sym, "Please enter the #{name.humanize.downcase}.") if resource_json[name].nil?
      end
    end
  end

  def check_resource_use_rights
    return unless is_ui_request?  || self.errors.messages.blank?

    unless resource_json['resource_use_rights_label']&.start_with?('CC')
      REQUIRED_FIELDS_RESOURCE_USE_RIGHTS.each do |name|
        errors.add(name.to_sym, "When the value of 'resource_use_rights_label' is '#{resource_json['resource_use_rights_label']}', '#{name}' is not needed.") if resource_json.has_key? name
      end
    end
  end

  def check_urls

    return unless is_ui_request?  || self.errors.messages.blank?

    resource_json['resource_keywords']&.each_with_index do |keyword,index|
      keyword['resource_keywords_label_code']
      unless validate_url(keyword['resource_keywords_label_code']&.strip)
        errors.add("resource_keywords[#{index}]['resource_keywords_label_code']".to_sym, 'is not a url.')
      end
    end

    unless validate_url(resource_json['resource_web_page']&.strip)
      errors.add('resource_web_page'.to_sym, 'is not a url.')
    end

    resource_json['roles']&.each_with_index do |role,index|
      unless validate_url(role['role_affiliation_web_page'].strip)
        errors.add("roles[#{index}]['role_affiliation_web_page']".to_sym, 'is not a url.')
      end
    end

    unless resource_json['study_design'].blank? || resource_json['study_design']['study_data_sharing_plan_url'].blank?
      unless validate_url(resource_json['study_design']['study_data_sharing_plan_url'].strip)
        errors.add('study_data_sharing_plan_url'.to_sym, 'is not a url.')
      end
    end

  end

  def check_numericality
    return unless is_ui_request?  || self.errors.messages.blank?

    study_design = resource_json['study_design']

    unless study_design.blank?
      INTEGER_ATTRIBUTES.each do |value|
        if resource_json['study_design'][value].blank?
          resource_json['study_design'][value] = nil
        else
          begin
            resource_json['study_design'][value] = Integer(study_design[value])
          rescue ArgumentError, TypeError
            errors.add(value.to_sym, 'The value must be an integer.')
          end
        end
      end

      FLOAT_ATTRIBUTES.each do |value|
        #@todo refactoring code, too long and not optimal
        if value == 'study_target_follow-up_duration'
          if study_design.key? 'non_interventional_study_design'
            duration = resource_json['study_design']['non_interventional_study_design'][value]
            if duration.blank?
              resource_json['study_design']['non_interventional_study_design'][value] = nil
            else
              begin
                resource_json['study_design']['non_interventional_study_design'][value] = Float(duration)
              rescue ArgumentError, TypeError
                errors.add(value.to_sym, 'The value must be an float.')
              end
            end
          end
        else
          if study_design[value].blank?
            resource_json['study_design'][value] = nil
          else
            begin
              resource_json['study_design'][value] = Float(resource_json['study_design'][value])
            rescue ArgumentError, TypeError
              errors.add(value.to_sym, 'The value must be an float.')
            end
          end
        end
      end

    end
  end


  def end_date_is_after_start_date
    return unless is_ui_request?  || self.errors.messages.blank?

    start_date = resource_json['study_design']['study_start_date']
    end_date = resource_json['study_design']['study_end_date']

    return if end_date.blank? || start_date.blank?

    unless is_ui_request?
      start_date = Date.parse(start_date).strftime('%Y-%m-%d') unless start_date.blank?
      end_date = Date.parse(end_date).strftime('%Y-%m-%d') unless start_date.blank?
    end

    errors.add(:study_end_date, 'cannot be before the start date') if end_date < start_date
  end


  def check_title_presence
    errors.add(:base, "Please add at least one title for the #{studyhub_resource_type_title}.") if title.blank?
  end

  def check_provenance_data_presence
    return if resource_json.blank?

    errors.add(:data_source, 'cannot be empty') if resource_json['provenance'].blank?
  end

  def check_id_presence
    return unless self.errors[:resource_json].blank?

    resource_json['ids']&.each_with_index do |id,index|
      unless id['id_identifier'].blank?
        errors.add("ids[#{index}]['id_type']".to_sym, "can't be blank")  if id['id_type'].blank?
        errors.add("ids[#{index}]['id_relation_type']".to_sym, "can't be blank")  if id['id_relation_type'].blank?
      end
    end
  end

  def check_nfdi_resource_id
    return unless self.errors[:resource_json].blank?

    resource_json['ids']&.each_with_index do |id,index|

      if id['id_type'] == 'NFDI4Health'
        begin
          a = Integer(id['id_identifier'])
        rescue ArgumentError, TypeError
          errors.add("ids[#{index}]['id_identifier']".to_sym, "The value must be the ID of the NFDI4Health resource. e.g.1")
        end
        begin

        end
        if StudyhubResource.where(id: id['id_identifier']).blank?
          errors.add("ids[#{index}]['id_identifier']".to_sym, "This NFDI4Health resource ID doesn't exist.")
        end

      end
    end
  end

  def check_role_presence

    return unless resource_json.has_key?('roles')

    if resource_json['roles'].blank?
      errors.add(:base, "Please add at least one resource role for the #{studyhub_resource_type_title}.")
      errors.add("roles[0]['role_type']".to_sym, "can't be blank")
      errors.add("roles[0]['role_name_type']".to_sym, "can't be blank")
    else
      resource_json['roles']&.each_with_index do |role,index|
        errors.add("roles[#{index}]['role_type']".to_sym, "can't be blank")  if role['role_type'].blank?
        errors.add("roles[#{index}]['role_name_type']".to_sym, "can't be blank")  if role['role_name_type'].blank?

        if role['role_name_type'] == 'Personal'

          if role['role_name_personal_title'].blank?
            errors.add("roles[#{index}]['role_name_personal_title']".to_sym, "can't be blank")
          end

          if role['role_name_personal_given_name'].blank?
            errors.add("roles[#{index}]['role_name_personal_given_name']".to_sym, "can't be blank")
          end

          if role['role_name_personal_family_name'].blank?
            errors.add("roles[#{index}]['role_name_personal_family_name']".to_sym, "can't be blank")
          end

          role['role_name_identifiers']&.each_with_index do |id,id_index|
            if !id['role_name_identifier'].blank? && id['role_name_identifier_scheme'].blank?
              errors.add("roles[#{index}]['role_name_identifier_scheme'][#{id_index}]".to_sym, 
                         'Please select the name identifier scheme.')
            end
          end

        end

        if role['role_name_type'] == 'Organisational'
          if role['role_name_organisational'].blank?
            errors.add("roles[#{index}]['role_name_organisational']".to_sym, "can't be blank")
          end
        end

        role['role_affiliation_identifiers']&.each_with_index do |id,id_index|
          if !id['role_affiliation_identifier'].blank? && id['role_affiliation_identifier_scheme'].blank?
            errors.add("roles[#{index}]['role_affiliation_identifier_scheme'][#{id_index}]".to_sym,
                       'Please select the affiliation identifier scheme.')

          end
        end

      end

      if errors.messages.keys.select {|x| x.to_s.include? 'roles' }.size  > 0
        errors.add(:base, 'Please add the required fields for resource roles.')
      end
    end
  end

  def check_description_presence
    errors.add(:description, "can't be blank") if resource_json['resource_descriptions'].blank? || resource_json['resource_descriptions'].reject {|desc| desc['description'].blank?}.blank?
  end

  def check_required_singular_attributes

    REQUIRED_FIELDS_RESOURCE_BASIC.each do |attr|
      errors.add(attr.to_sym, "Please enter the #{attr.humanize.downcase}.") if resource_json[attr].blank?
    end
    if is_studytype?
      REQUIRED_FIELDS_STUDY_DESIGN_GENERAL.each do |attr|
        errors.add(attr.to_sym, "Please enter the #{attr.humanize.downcase}.") if resource_json['study_design'][attr].blank?
      end
    end
  end

  def check_required_multi_attributes
    return unless errors.messages[:resource_json].blank?

    resource_json['study_design']['study_conditions']&.each_with_index  do |condition, index|
      if !condition['study_conditions'].blank? && condition['study_conditions_classification'].blank?
        errors.add("study_conditions_classification[#{index}]".to_sym, 'Please select the study conditions classification.')
      end
    end

    resource_json['study_design']['study_outcomes']&.each_with_index  do |outcome, index|
      if !outcome['study_outcome_title'].blank? && outcome['study_outcome_type'].blank?
        errors.add("study_outcome_type[#{index}]".to_sym, 'Please select the type of the outcome measure.')
      end
    end

    if  self.is_interventional_study?
      resource_json['study_design']['interventional_study_design']['interventional_study_design_arms']&.each_with_index  do |arm, index|
        if !arm['study_arm_group_label'].blank? && arm['study_arm_group_type'].blank?
          errors.add("study_arm_group_type[#{index}]".to_sym, 'Please select the role of the arm.')
        end
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
    self.studyhub_resource_type.is_studytype?
  end

  def is_interventional_study?
     self.get_study_primary_design_type == 'Interventional'
  end

  def is_non_interventional_study?
    self.get_study_primary_design_type == 'Non-interventional'
  end

  # if the resource type is study or substudy
  def get_study_primary_design_type
    return nil unless is_studytype?
    resource_json['study_design']['study_primary_design']
  end

  def set_resource_titles_to_title
    self.title = resource_json['resource_titles']&.first.blank?? nil : resource_json['resource_titles']&.first['title']
  end

  def covert_to_mds_date_format

    self.resource_json['ids']&.each_with_index do |id,index|
      self.resource_json['ids'][index]['id_date'] = convert_date_format(id['id_date']) unless id['id_date'].blank?
    end

    if self.is_studytype?
      StudyhubResource::DATE_TYPE.each do |attr|
        self.resource_json['study_design'][attr] = convert_date_format(self.resource_json['study_design'][attr]) unless self.resource_json['study_design'][attr].blank?
      end
    end
  end

  def convert_date_format(date)
    Date.parse(date).strftime('%d.%m.%Y')
  end


  def convert_label_to_id_for_multi_select_attribute

    return unless errors.messages[:resource_json].empty?
    self.resource_json['resource_language'] = resource_json['resource_language'].blank? ? [] : covert_label_to_id(resource_json['resource_language'])

    if self.is_studytype?

      StudyhubResource::MULTISELECT_ATTRIBUTES_HASH['study_design'].each do |attr|
        self.resource_json['study_design'][attr] = resource_json['study_design'][attr].blank? ? []: covert_label_to_id(resource_json['study_design'][attr])
      end

      case self.get_study_primary_design_type

      when StudyhubResource::INTERVENTIONAL
        StudyhubResource::MULTISELECT_ATTRIBUTES_HASH['interventional_study_design'].each do |attr|
          self.resource_json['study_design']['interventional_study_design'][attr] = resource_json['study_design']['interventional_study_design'][attr].blank? ? []: covert_label_to_id(resource_json['study_design']['interventional_study_design'][attr])
        end

      when StudyhubResource::NON_INTERVENTIONAL
        StudyhubResource::MULTISELECT_ATTRIBUTES_HASH['non_interventional_study_design'].each do |attr|
          self.resource_json['study_design']['non_interventional_study_design'][attr] = resource_json['study_design']['non_interventional_study_design'][attr].blank? ? []: covert_label_to_id(resource_json['study_design']['non_interventional_study_design'][attr])
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
    self.to_i.to_s == self
  end

  # https://newbedev.com/how-to-check-if-a-url-is-valid
  def validate_url(url)

    return true if url.blank?

    begin
      uri = URI.parse(url)
      resp = uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
    rescue URI::InvalidURIError
      resp = false
    end
    # return true if url =~ /\A#{URI::regexp(['http', 'https'])}\z/
  end

end
