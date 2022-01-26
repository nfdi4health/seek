class StudyhubResource < ApplicationRecord

  belongs_to :studyhub_resource_type, inverse_of: :studyhub_resources

  has_one :content_blob,:as => :asset, :foreign_key => :asset_id

  has_extended_custom_metadata
  acts_as_asset

  validate :check_title_presence, on:  [:create, :update]
  validate :check_urls, on:  [:create, :update]
  validate :check_provenance_data_presence, on:  [:create, :update]
  validate :check_numericality, on:  [:create, :update], if: :is_studytype?
  validate :end_date_is_after_start_date, on: [:create, :update], if: :is_studytype?
  validate :check_id_presence, on: [:create, :update], if: ->{request_to_submit? || request_to_publish?}
  validate :check_role_presence, on: [:create, :update], if: ->{request_to_submit? || request_to_publish?}
  validate :check_description_presence, on:  [:create, :update], if: ->{request_to_submit? || request_to_publish?}
  validate :check_required_singular_attributes, on:  [:create, :update], if: ->{request_to_submit? || request_to_publish?}
  validate :check_required_multi_attributes, on:  [:create, :update], if: -> {request_to_submit? && is_studytype?}

  validate :final_error_check, on:  [:create, :update]

  attr_readonly :studyhub_resource_type_id
  attr_accessor :commit_button
  before_save :update_working_stage, on:  [:create, :update]


  # *****************************************************************************
  #  This section defines constants for "mandatory fields" values
  #
  REQUIRED_FIELDS_RESOURCE_BASIC = %w[resource_type_general resource_use_rights_label].freeze
  REQUIRED_FIELDS_RESOURCE_USE_RIGHTS = %w[resource_use_rights_authors_confirmation_1 resource_use_rights_authors_confirmation_2 resource_use_rights_authors_confirmation_3 resource_use_rights_support_by_licencing].freeze
  REQUIRED_FIELDS_STUDY_DESIGN_GENERAL = ['study_primary_design','study_status','study_data_sharing_plan_generally','study_country','study_subject'].freeze
  REQUIRED_FIELDS_INTERVENTIONAL = %w[study_type_interventional].freeze
  REQUIRED_FIELDS_NON_INTERVENTIONAL = %w[study_type_non_interventional].freeze
  INTERVENTIONAL = 'Interventional'.freeze
  NON_INTERVENTIONAL = 'Non-interventional'.freeze
  URL_FIELDS = %w[resource_web_page study_data_sharing_plan_url].freeze
  RESOURCE_KEYWORDS = 'resource_keywords'.freeze
  ID_TYPE = %w[name affiliation].freeze

  # *****************************************************************************
  #  This section defines constants for "working stages" values

  SAVED = 0
  SUBMITTED  = 1
  WAITING_FOR_APPROVEL = 2
  PUBLISHED = 3

  # *****************************************************************************
  #  This section defines constants for multiselect attributes
  MULTISELECT_ATTRIBUTES_HASH = {'resource' => %w[resource_language],
                                 'study_design' => %w[study_data_source study_country study_data_sharing_plan_supporting_information study_eligibility_gender study_masking_roles study_biospecimen_retention] }.freeze

  # *****************************************************************************
  #  This section defines attributes which have 0-n relationship
  MULTI_ATTRIBUTE_FIELDS_LIST_STYLE =  { 'study_conditions' => %w[study_conditions study_conditions_classification study_conditions_classification_code],
                                         'study_outcomes' => %w[study_outcome_type study_outcome_title study_outcome_description study_outcome_time_frame],
                                         'interventional_study_design_arms' => %w[study_arm_group_label study_arm_group_type study_arm_group_description],
                                         'interventional_study_design_interventions' => %w[study_intervention_name study_intervention_type study_intervention_description study_intervention_arm_group_label]

  }.freeze

  MULTI_ATTRIBUTE_FIELDS_ROW_STYLE =  { 'resource_keywords' => %w[resource_keywords_label resource_keywords_label_code]
  }.freeze

  MULTI_ATTRIBUTE_SKIPPED_FIELDS = %w[resource_keywords_label resource_keywords_label_code study_conditions_classification study_conditions_classification_code
                                    study_outcome_type study_outcome_title study_outcome_description study_outcome_time_frame
                                    study_arm_group_label study_arm_group_type study_arm_group_description
                                    study_intervention_name study_intervention_type study_intervention_description study_intervention_arm_group_label study_recruitment_status_register].freeze


  NOT_PUBLIC_DISPLAY_ATTRIBUTES =  %w[study_recruitment_status_register].freeze

  INTEGER_ATTRIBUTES =  %w[study_centers_number study_target_sample_size study_obtained_sample_size].freeze
  FLOAT_ATTRIBUTES =  %w[study_eligibility_age_min study_eligibility_age_max study_age_min_examined study_age_max_examined study_target_follow-up_duration].freeze

  def description
    if resource_json.nil? || resource_json['resource_descriptions'].blank?
      'Studyhub Resources'
    else
      resource_json['resource_descriptions'].first['description']
    end
  end



  def check_urls
    return if resource_json.nil?

    unless resource_json['resource'].blank? || validate_url(resource_json['resource']['resource_web_page'].strip)
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
    unless resource_json.nil? || resource_json['study_design'].blank?
      INTEGER_ATTRIBUTES.reject {|x| resource_json['study_design'][x].blank?}.each do |value|
        Integer(resource_json['study_design'][value])
      rescue ArgumentError, TypeError
        errors.add(value.to_sym, 'The value must be an integer.')
      end

      FLOAT_ATTRIBUTES.reject {|x| resource_json['study_design'][x].blank?}.each do |value|
        Float(resource_json['study_design'][value])
      rescue ArgumentError, TypeError
        errors.add(value.to_sym, 'The value must be a float.')
      end
    end
  end


  def end_date_is_after_start_date

    return if resource_json.blank?

    start_date = resource_json['study_design']['study_start_date']
    end_date = resource_json['study_design']['study_end_date']

    return if end_date.blank? || start_date.blank?

    errors.add(:study_end_date, 'cannot be before the start date') if end_date < start_date
  end


  def check_title_presence
    errors.add(:base, "Please add at least one title for the #{studyhub_resource_type_title}.") if title.blank?
  end

  def check_provenance_data_presence
    errors.add(:data_source, 'cannot be empty') if resource_json['provenance'].blank?
  end

  def check_id_presence
    resource_json['ids']&.each_with_index do |id,index|
      unless id['id_id'].blank?
        errors.add("ids[#{index}]['id_type']".to_sym, "can't be blank")  if id['id_type'].blank?
        errors.add("ids[#{index}]['id_relation_type']".to_sym, "can't be blank")  if id['id_relation_type'].blank?
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

          ID_TYPE.each do |type|
            role["role_#{type}_identifiers"]&.each_with_index do |id,id_index|
              if !id["role_#{type}_identifier"].blank? && id["role_#{type}_identifier_scheme"].blank?
                errors.add("roles[#{index}]['role_#{type}_identifier_scheme'][#{id_index}]".to_sym, 'Please select the identifier scheme.')
              end
            end
          end
        end

        if role['role_name_type'] == 'Organisational'
          if role['role_name_organisational'].blank?
            errors.add("roles[#{index}]['role_name_organisational']".to_sym, "can't be blank")
          end
        end
      end

      if errors.messages.keys.select {|x| x.to_s.include? 'roles' }.size  > 0
        errors.add(:base, 'Please add the required fields for resource roles.')
      end
    end
  end

  def check_description_presence
    errors.add(:description, "can't be blank") if resource_json['resource_descriptions'].blank?
  end

  def check_required_singular_attributes

    required_fields ={}
    required_fields['resource'] = REQUIRED_FIELDS_RESOURCE_BASIC
    if resource_json['resource']['resource_use_rights_label'].start_with?('CC')
      required_fields['resource'] += REQUIRED_FIELDS_RESOURCE_USE_RIGHTS
    end

    if is_studytype?

      required_fields['study_design'] =  REQUIRED_FIELDS_STUDY_DESIGN_GENERAL

      if get_study_primary_design_type == INTERVENTIONAL
        required_fields['study_design'] += REQUIRED_FIELDS_INTERVENTIONAL
      end

      if get_study_primary_design_type == NON_INTERVENTIONAL
        required_fields['study_design'] += REQUIRED_FIELDS_NON_INTERVENTIONAL
      end

    end

    required_fields.each do |type, fields|
      fields.each do |name|
        errors.add(name.to_sym, "Please enter the #{name.humanize.downcase}.") if resource_json[type][name].blank?
      end
    end
  end

  def check_required_multi_attributes
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

    resource_json['study_design']['interventional_study_design_arms']&.each_with_index  do |arm, index|
      if !arm['study_arm_group_label'].blank? && arm['study_arm_group_type'].blank?
        errors.add("study_arm_group_type[#{index}]".to_sym, 'Please select the role of the arm.')
      end
    end

  end

  def final_error_check
    errors.add(:base, 'Please make sure all required fields are filled in correctly.') unless errors.messages.empty?
  end

  def request_to_submit?
    commit_button == 'Submit'
  end

  def request_to_publish?
    commit_button == 'Publish'
  end

  def is_submitted?
    stage == StudyhubResource::SUBMITTED
  end

  def studyhub_resource_type_title
    StudyhubResourceType.find(studyhub_resource_type_id).title.downcase
  end

  def update_working_stage
    self.stage = if request_to_submit?
                   StudyhubResource::SUBMITTED
                 elsif request_to_publish?
                   StudyhubResource::SUBMITTED
                 else
                   StudyhubResource::SAVED
                 end

  end

  # if the resource type is study or non_study
  def is_studytype?
    self.studyhub_resource_type.is_studytype?
  end

  # if the resource type is study or substudy
  def get_study_primary_design_type
    resource_json['study_design']['study_primary_design']
  end

  # translates stage codes into human-readable form
  def self.get_stage_wording(stage)
    case stage
    when StudyhubResource::SAVED
      'saved'
    when StudyhubResource::SUBMITTED
      'submitted'
    when StudyhubResource::WAITING_FOR_APPROVEL
      'waiting for approval'
    when StudyhubResource::PUBLISHED
      'published'
    else
      'unknown'
    end
  end

  private

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
