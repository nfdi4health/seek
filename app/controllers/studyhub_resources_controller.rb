class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon
  include Seek::DestroyHandling

  before_action :find_and_authorize_studyhub_resource, only: %i[edit update destroy manage show]
  api_actions :index, :show, :create, :update, :destroy

  def index
    #http://localhost:3003/studyhub_resources.json?type=study
    resources_expr = "StudyhubResource.all"
    if params[:type].present?
      type_id = StudyhubResourceType.find_by(key: params[:type]).id
      resources_expr << ".where(studyhub_resource_type_id: type_id)"
    end
    resources_expr << ".where({updated_at: params[:after].to_time..Time.now})" if params[:after].present?
    resources_expr << ".where({updated_at: Time.at(0)..params[:before].to_time})" if params[:before].present?

    if params[:limit].present?
      resources_expr << ".limit params[:limit]"
      @studyhub_resources = eval resources_expr
    elsif params[:all].present?
      @studyhub_resources = eval resources_expr
    else
      @studyhub_resources = eval resources_expr + '.limit 10'
    end

    respond_to do |format|
      format.html
      format.xml
      format.json { render json: @studyhub_resources }
    end
  end

  def show
    @studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
      format.json { render json: @studyhub_resource }
    end
  end

  def create
    @studyhub_resource = StudyhubResource.new(studyhub_resource_params)

    resource_type = @studyhub_resource.studyhub_resource_type

    if resource_type.nil?
      render json: { error: 'Studyhub API Error',
                     message: 'Studyhub resource type is blank or invalid.' }, status: :bad_request

    else
      seek_type = map_to_seek_type(resource_type)

      item = nil

      case seek_type
      when 'Study'
        Rails.logger.info('creating a SEEK Study')
        item = @studyhub_resource.build_study(study_params)
      when 'Assay'
        Rails.logger.info('creating a SEEK Assay')
        item = @studyhub_resource.build_assay(assay_params)
      end

      update_sharing_policies item

      #todo only save @studyhub_resource when item(study/assay) is created successfully
      if item.valid?
        if @studyhub_resource.save
          update_parent_child_relationships(relationship_params)
          render json: @studyhub_resource, status: :created, location: @studyhub_resource
        else
          render json: @studyhub_resource.errors, status: :unprocessable_entity
        end
      else
        @studyhub_resource.errors.add(:base, item.errors.full_messages)
        render json: @studyhub_resource.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /studyhub_resources/1
  def update
    @studyhub_resource.update_attributes(studyhub_resource_params)
    update_parent_child_relationships(relationship_params)

    unless @studyhub_resource.study.nil?
      update_sharing_policies @studyhub_resource.study
      @studyhub_resource.study.update_attributes(study_params)
    end

    unless @studyhub_resource.assay.nil?
      update_sharing_policies @studyhub_resource.assay
      @studyhub_resource.assay.update_attributes(assay_params)
    end

    respond_to do |format|
      if @studyhub_resource.save
        @studyhub_resource.reload
        format.json { render json: @studyhub_resource, status: 200 }
      else
        format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
      end
    end
  end

  private

  def study_params
    assay_ids = get_assay_ids(relationship_params) if relationship_params.key?('child_ids')
    # investigation_id =  params[:studyhub_resource][:investigation_id] || (@studyhub_resource.study.investigation.id unless @studyhub_resource.study.nil?)

    investigation_id =1 # hu_test
    resource_json = studyhub_resource_params['resource_json']


    title =  params[:studyhub_resource] || resource_json['titles'].first['title'] # hu_test
    description = resource_json['descriptions'].first['description_text'] unless resource_json['descriptions'].blank?

    cmt, metadata = extract_custom_metadata('study')

    params_hash = {
      title: title,
      description: description,
      investigation_id: investigation_id,
      # hu_test
      # custom_metadata_attributes: {
      #   custom_metadata_type_id: cmt.id, data: metadata
      # }
    }
    params_hash['assay_ids'] = assay_ids unless assay_ids.nil?
    params_hash
  end

  def assay_params

    study_id = get_study_id(relationship_params)
    resource_json = studyhub_resource_params['resource_json']
    title = resource_json['titles'].first['title']
    description = resource_json['descriptions'].first['description_text'] unless resource_json['descriptions'].blank?

    cmt, metadata = extract_custom_metadata('assay')

    {
      # currently the assay class is set as modelling type by default
      assay_class_id: AssayClass.for_type('modelling').id,
      title: title,
      description: description,
      study_id: study_id,
      custom_metadata_attributes: {
        custom_metadata_type_id: cmt.id, data: metadata
      },
      document_ids: seek_relationship_params['document_ids']
    }
  end

  def studyhub_resource_params

    params[:studyhub_resource][:resource_json] = {}

    # parse titles

    resource_titles = []

    params[:studyhub_resource][:resource_title].keys.each do |key|
      entry = {}

      entry["title"] = params[:studyhub_resource][:resource_title][key]
      entry["title_language"] = params[:studyhub_resource][:resource_language][key]
      resource_titles << entry unless entry["title"].blank?
    end

    params[:studyhub_resource][:resource_json][:resource_titles] = resource_titles


    # parse descriptions
    #
    resource_descriptions = []

    params[:studyhub_resource][:description_text].keys.each do |key|
      entry = {}

      entry["description_text"] = params[:studyhub_resource][:description_text][key]
      entry["description_language"] = params[:studyhub_resource][:description_language][key]
      resource_descriptions << entry unless entry["description_text"].blank?
    end

    params[:studyhub_resource][:resource_json][:resource_descriptions] = resource_descriptions


    # parse resource information and study design
    unless params[:studyhub_resource][:custom_metadata_attributes].nil?

      resource_attributes = %w[resource_type_general resource_language resource_use_rights resource_web_page resource_web_studyhub resource_web_seek resource_web_mica acronym]
      study_design_attributes = %w[study_primary_design study_type_interventional study_type_non_interventional study_type_description
                                 study_primary_purpose study_conditions study_conditions_code study_keywords study_centers study_subject study_region study_target_sample_size
                                 study_obtained_sample_size study_age_min study_age_max study_sex study_inclusion_criteria study_exclusion_criteria study_population study_sampling
                                 study_hypothesis study_design_comment study_IPD_sharing_plan_generally study_IPD_sharing_plan_description stuy_IPD_sharing_plan_time_frame stuy_IPD_sharing_plan_access_criteria
                                 stuy_IPD_sharing_plan_url study_start_date study_end_date study_status study_country study_eligibility]

      resource = {}
      study_design = {}


      params[:studyhub_resource][:custom_metadata_attributes][:data].keys.each do |key|
        if resource_attributes.include? key

          resource[key] = params[:studyhub_resource][:custom_metadata_attributes][:data][key]

          elsif study_design_attributes.include? key
            study_design[key] = params[:studyhub_resource][:custom_metadata_attributes][:data][key]

        end
      end
      params[:studyhub_resource][:resource_json][:resource] = resource
      params[:studyhub_resource][:resource_json][:study_design] = study_design
    end

    rt = StudyhubResourceType.where(key: params[:studyhub_resource][:studyhub_resource_type]).first
    params[:studyhub_resource][:studyhub_resource_type_id] = rt.id unless rt.nil?

    params.require(:studyhub_resource).permit(:studyhub_resource_type_id, :comment, { resource_json: {} }, \
                                            :nfdi_person_in_charge, :contact_stage, :data_source, \
                                            :comment, :exclusion_mica_reason, :exclusion_seek_reason, \
                                            :exclusion_studyhub_reason, :inclusion_studyhub, :inclusion_seek, \
                                            :inclusion_mica)
  end

  def relationship_params
    params.require(:studyhub_resource).permit(parent_ids: [], child_ids: [])
  end

  def seek_relationship_params
    params.require(:studyhub_resource).permit(document_ids:[])
  end

  def map_to_seek_type(resource_type)
    case resource_type.key
    when 'study'
      'Study'
    when 'substudy'
      'Study'
    else
      'Assay'
    end
  end

  #due to the constraints of ISA, a assay can only have one study associated.
  def get_study_id(relationship_params)

    study_id = nil

    #ToDo assign assay without parent to a default study. remove the hard code.
    other_studyhub_resource_id = Seek::Config.nfdi_other_studyhub_resource_id

    # if resource has no parents, assign it to "other studies"
    if relationship_params['parent_ids'].blank?
      study_id = other_studyhub_resource_id
    else

        parent = StudyhubResource.find(relationship_params['parent_ids'].first)

        # TODO: when parents are other types, such as "instrument", "document"
        # TODO: if parent doesnt exist, still need to sort out the relationship
        study_id = if !parent.nil? && (parent.is_study? || parent.is_substudy?)
                     parent.study.id
                   else
                     other_studyhub_resource_id
                   end
    end
    study_id
  end

  def get_assay_ids(relationship_params)
    assay_ids = []
    unless relationship_params['child_ids'].blank?
      relationship_params['child_ids'].each do |child_id|
        child = StudyhubResource.find(child_id)
        unless (child.nil? || child.assay.nil?)
          assay_ids << child.assay.id
        end
      end
    end
    assay_ids
  end

  def extract_custom_metadata(resource_type)
    if CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata', supported_type: resource_type).any?
      cmt = CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata',
                                     supported_type: resource_type).first
    end

    resource_json = @studyhub_resource.resource_json

    metadata = {
      "resource_web_studyhub": resource_json['resource_web_studyhub'],
      "resource_type": @studyhub_resource.studyhub_resource_type.title,
      "resource_web_page": resource_json['resource_web_page'],
      "resource_web_mica": resource_json['resource_web_mica']
      # "acronym": resource_json['acronyms'].first['acronym']
    }

    if resource_json.key? 'study'
      study_start_date = if resource_json['study']['study_start_date'].nil?
                           nil
                         else
                           Date.strptime(
                             resource_json['study']['study_start_date'], '%Y-%m-%d'
                           )
                         end
      study_end_date = if resource_json['study']['study_end_date'].nil?
                         nil
                       else
                         Date.strptime(
                           resource_json['study']['study_end_date'], '%Y-%m-%d'
                         )
                       end

      metadata = metadata.merge({
                                  "study_type": resource_json['study']['study_type'],
                                  "study_start_date": study_start_date,
                                  "study_end_date": study_end_date,
                                  "study_status": resource_json['study']['study_status'],
                                  "study_country": resource_json['study']['study_country'],
                                  "study_eligibility": resource_json['study']['study_eligibility']
                                })
    end

    [cmt, metadata]
  end


  def find_and_authorize_studyhub_resource
    @studyhub_resource = StudyhubResource.find(params[:id])
    privilege = Seek::Permissions::Translator.translate(action_name)

    @seek_item ||= @studyhub_resource.study
    @seek_item ||= @studyhub_resource.assay

    return if privilege.nil?
    unless is_auth?(@seek_item, privilege)
      respond_to do |format|
        flash[:error] = 'You are not authorized to perform this action'
        format.html { redirect_to @studyhub_resource }
        format.json do
          render json: { "title": 'Forbidden',
                         "detail": "You are not authorized to perform this action." },
                 status: :forbidden
        end
      end
    end
  end

  def update_parent_child_relationships(params)
    if params.key?(:parent_ids)
      @studyhub_resource.parents = []
      params['parent_ids'].each do |x|
        parent = StudyhubResource.find(x)
        if parent.nil?
          @studyhub_resource.errors.add(:id, "Studyhub Resource id #{x} doesnt exist!")
        else
          @studyhub_resource.add_parent(parent)
      end
      end
    end

    if params.key?(:child_ids)
      @studyhub_resource.children = []
      params['child_ids'].each do |x|
        child = StudyhubResource.find(x)
        if child.nil?
          @studyhub_resource.errors.add(:id, "Studyhub Resource id #{x} doesnt exist!")
        else
          @studyhub_resource.add_child(child)
        end
      end
    end
  end
end