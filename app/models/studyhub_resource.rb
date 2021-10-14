class StudyhubResource < ApplicationRecord

  belongs_to :assay, optional: true, dependent: :destroy
  belongs_to :study, optional: true, dependent: :destroy
  belongs_to :studyhub_resource_type, inverse_of: :studyhub_resources

  has_many :children_relationships, class_name: 'StudyhubResourceRelationship',
           foreign_key: 'parent_id',
           dependent: :destroy

  has_many :children, through: :children_relationships

  has_many :parents_relationships, class_name: 'StudyhubResourceRelationship',
           foreign_key: 'child_id',
           dependent: :destroy

  has_many :parents, through: :parents_relationships
  has_one :content_blob,:as => :asset, :foreign_key => :asset_id


  has_extended_custom_metadata
  acts_as_asset

  validate :check_title_presence, on:  [:create, :update]
  validate :check_urls, on:  [:create, :update]
  validate :check_id_presence, on: [:create, :update], if: :request_to_submit?
  validate :check_role_presence, on: [:create, :update], if: :request_to_submit?
  validate :check_description_presence, on:  [:create, :update], if: :request_to_submit?
  validate :full_validations_before_submit, on:  [:create, :update], if: :request_to_submit?
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

  # *****************************************************************************
  #  This section defines constants for "working stages" values

  SAVED = 0
  SUBMITTED  = 1
  WAITING_FOR_APPROVEL = 2
  PUBLISHED = 3

  # *****************************************************************************
  #  This section defines constants for multiselect attributes
  MULTISELECT_ATTRIBUTES = %w[resource_language study_data_source study_country study_data_sharing_plan_supporting_information study_eligibility_gender study_masking_roles study_time_perspective study_biospecimen_retention].freeze

  def description
    if resource_json.nil? || resource_json['resource_descriptions'].blank?
      'Studyhub Resources'
    else
      "#{resource_json['resource_descriptions'].first['description']}"
    end
  end



  def check_urls

    unless validate_url(resource_json['resource']['resource_web_page'].strip)
      errors.add('resource_web_page'.to_sym, 'is not a url.')
    end

    unless resource_json['roles'].blank?
      resource_json['roles'].each_with_index do |role,index|
        unless validate_url(role['role_affiliation_web_page'].strip)
          errors.add("roles[#{index}]['role_affiliation_web_page']".to_sym, 'is not a url.')
        end
      end
    end


    unless resource_json['study_design']['study_data_sharing_plan_url'].blank?
      unless validate_url(resource_json['study_design']['study_data_sharing_plan_url'].strip)
        errors.add('study_data_sharing_plan_url'.to_sym, 'is not a url.')
      end
    end

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


  def check_title_presence
    errors.add(:base, "Please add at least one title for the #{studyhub_resource_type_title}.") if title.blank?
  end


  def check_id_presence

    resource_json['ids'].each_with_index do |id,index|
      unless id['id_id'].blank?
        errors.add("ids[#{index}]['id_type']".to_sym, "can't be blank")  if id['id_type'].blank?
        errors.add("ids[#{index}]['id_relation_type']".to_sym, "can't be blank")  if id['id_relation_type'].blank?
      end
    end
  end

  def check_role_presence

    if resource_json['roles'].blank?
      errors.add(:base, "Please add at least one resource role for the #{studyhub_resource_type_title}.")
      errors.add("roles[0]['role_type']".to_sym, "can't be blank")
      errors.add("roles[0]['role_name_type']".to_sym, "can't be blank")
    else
      resource_json['roles'].each_with_index do |role,index|
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
          if !role['role_name_identifier'].blank? && role['role_name_identifier_scheme'].blank?
            errors.add("roles[#{index}]['role_name_identifier_scheme']".to_sym, "Please select the identifier scheme.")
          end
        end

        if role['role_name_type'] == 'Organisational'
          if role['role_name_organisational'].blank?
            errors.add("roles[#{index}]['role_name_organisational']".to_sym, "can't be blank")
          end
          if !role['role_affiliation_identifier'].blank? && role['role_affiliation_identifier_scheme'].blank?
            errors.add("roles[#{index}]['role_affiliation_identifier_scheme']".to_sym, "Please select the affiliation identifier scheme.")
          end
        end

        if !role['role_affiliation_identifier'].blank? && role['role_affiliation_identifier_scheme'].blank?
          errors.add("roles[#{index}]['role_affiliation_identifier_scheme']".to_sym, "Please select the affiliation identifier scheme.")
        end

      end
      if errors.messages.keys.select {|x| x.to_s.include? "roles" }.size  > 0
        errors.add(:base, "Please add the required fields for resource roles.")
      end
    end
  end

  def check_description_presence
    errors.add(:description, "can't be blank") if resource_json['resource_descriptions'].blank?
  end

  def full_validations_before_submit

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
      if !resource_json["study_design"]["study_conditions"].blank?
        required_fields['study_design'] += ['study_conditions_classification']
      end
      if !resource_json["study_design"]["study_arm_group_label"].blank?
        required_fields['study_design'] += ['study_arm_group_type']
      end
      unless resource_json["study_design"]["study_outcome_title"].blank? && resource_json["study_design"]["study_outcome_description"].blank?
        required_fields['study_design'] += ['study_outcome_type']
      end
    end

    required_fields.each do |type, fields|
      fields.each do |name|
        errors.add(name.to_sym, "Please enter the #{name.humanize.downcase}.") if resource_json[type][name].blank?
      end
    end
  end

  def final_error_check
    errors.add(:base, 'Please make sure all required fields are filled in correctly.') unless errors.messages.empty?
  end

  def check_content_blob_presence
    unless is_studytype?
      if content_blob.blank?
        errors.add(:base, "Please save the #{studyhub_resource_type_title} at first and then upload a file  ")
      end
    end
  end


  def request_to_submit?
    (commit_button == 'Submit') ? true : false
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
                 else
                   StudyhubResource::SAVED
                 end
  end

  def add_child(child)
    children_relationships.create(child_id: child.id)
  end

  def remove_child(child)
    children_relationships.find_by(child_id: child.id).destroy
  end

  def is_parent?(child)
    children.include?(child)
  end

  def add_parent(parent)
    parents_relationships.create(parent_id: parent.id)
  end

  def remove_parent(parent)
    parents_relationships.find_by(parent_id: parent.id).destroy
  end

  def is_child?(parent)
    parents.include?(parent)
  end

  # if the resource type is study or substudy
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


end
