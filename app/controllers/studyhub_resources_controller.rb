class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon
  include Seek::DestroyHandling
  include Seek::IndexPager

  # before_action :find_and_authorize_studyhub_resource, only: %i[edit update destroy manage show]

  before_action :find_and_authorize_requested_item, only: %i[edit update destroy manage manage_update show new_object_based_on_existing_one]

  before_action :find_assets, only: [:index]
  api_actions :index, :show, :create, :update, :destroy

  def show
    @studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @studyhub_resource }
    end
  end

  def create

    @studyhub_resource = StudyhubResource.new(studyhub_resource_params)

    #todo(hu) remove studyhub_resource_type, and redo when the request is from API
    # resource_type = @studyhub_resource.studyhub_resource_type
    #
    # if resource_type.nil?
    #   render json: { error: 'Studyhub API Error',
    #                  message: 'Studyhub resource type is blank or invalid.' }, status: :bad_request
    #
    # else
       # seek_type = map_to_seek_type(resource_type)

      # item = nil
      #
      # case seek_type
      # when 'Study'
      #   Rails.logger.info('creating a SEEK Study')
      #   item = @studyhub_resource.build_study(study_params)
      # when 'Assay'
      #   Rails.logger.info('creating a SEEK Assay')
      #   item = @studyhub_resource.build_assay(assay_params)
      # end
      # update_sharing_policies item
    
    
      #todo(hu) next time when add relationship
      #update_parent_child_relationships(relationship_params)

    update_sharing_policies @studyhub_resource

      #todo(hu) only save @studyhub_resource when item(study/assay) is created successfully
      #if item.valid?
    if @studyhub_resource.save


      respond_to do |format|
        flash[:notice] = "The #{t('studyhub_resource')} was successfully created.<br/>".html_safe
        format.html { redirect_to studyhub_resource_path(@studyhub_resource) }
        format.json { render json: @studyhub_resource, status: :created, location: @studyhub_resource }
      end
    else
      respond_to do |format|
        format.html { render action: 'new', status: :unprocessable_entity }
        format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
      end
    end
      # else
      #   @studyhub_resource.errors.add(:base, item.errors.full_messages)
      #   render json: @studyhub_resource.errors, status: :unprocessable_entity
      # end
    
  end

  def edit
    @studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end

  # PUT /studyhub_resources/1
  def update

    update_sharing_policies @studyhub_resource
    update_relationships(@studyhub_resource,params)
    update_parent_child_relationships(relationship_params)

    # unless @studyhub_resource.study.nil?
    #   update_sharing_policies @studyhub_resource.study
    #   @studyhub_resource.study.update_attributes(study_params)
    # end
    #
    # unless @studyhub_resource.assay.nil?
    #   update_sharing_policies @studyhub_resource.assay
    #   @studyhub_resource.assay.update_attributes(assay_params)
    # end

    # respond_to do |format|
    #   if @studyhub_resource.save
    #     @studyhub_resource.reload
    #     format.json { render json: @studyhub_resource, status: 200 }
    #   else
    #     format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
    #   end
    # end
    #
    respond_to do |format|
      if  @studyhub_resource.update_attributes(studyhub_resource_params)
        flash[:notice] = "#{t('studyhub_resource')} metadata was successfully updated."
        format.html { redirect_to studyhub_resource_path(@studyhub_resource) }
        format.json { render json: @studyhub_resource, status: 200 }
      else
        format.html { render action: 'edit' }
        format.json { render json: json_api_errors(@workflow), status: :unprocessable_entity }
      end
    end
  end



  private

  # def study_params
  #   assay_ids = get_assay_ids(relationship_params) if relationship_params.key?('child_ids')
  #   # investigation_id =  params[:studyhub_resource][:investigation_id] || (@studyhub_resource.study.investigation.id unless @studyhub_resource.study.nil?)
  #
  #   investigation_id =1 # hu_test
  #   resource_json = studyhub_resource_params['resource_json']
  #
  #
  #   title =  params[:studyhub_resource] || resource_json['titles'].first['title'] # hu_test
  #   description = resource_json['descriptions'].first['description_text'] unless resource_json['descriptions'].blank?
  #
  #   cmt, metadata = extract_custom_metadata('study')
  #
  #   params_hash = {
  #     title: title,
  #     description: description,
  #     investigation_id: investigation_id,
  #     # hu_test
  #     # custom_metadata_attributes: {
  #     #   custom_metadata_type_id: cmt.id, data: metadata
  #     # }
  #   }
  #   params_hash['assay_ids'] = assay_ids unless assay_ids.nil?
  #   params_hash
  # end

  # def assay_params
  #
  #   study_id = get_study_id(relationship_params)
  #   resource_json = studyhub_resource_params['resource_json']
  #   title = resource_json['titles'].first['title']
  #   description = resource_json['descriptions'].first['description_text'] unless resource_json['descriptions'].blank?
  #
  #   cmt, metadata = extract_custom_metadata('assay')
  #
  #   {
  #     # currently the assay class is set as modelling type by default
  #     assay_class_id: AssayClass.for_type('modelling').id,
  #     title: title,
  #     description: description,
  #     study_id: study_id,
  #     custom_metadata_attributes: {
  #       custom_metadata_type_id: cmt.id, data: metadata
  #     },
  #     document_ids: seek_relationship_params['document_ids']
  #   }
  # end

  def studyhub_resource_params

    params[:studyhub_resource][:resource_json] = {}
    sr = params[:studyhub_resource]
    # parse titles
    sr[:resource_json][:resource_titles] = parse_resource_titles(sr)

    # parse descriptions
    sr[:resource_json][:resource_descriptions] = parse_resource_descriptions(sr)


    # parse IDs
    sr[:resource_json][:ids] = parse_ids(sr)


    # parse roles
    sr[:resource_json][:roles] = parse_roles(sr)


    params[:studyhub_resource][:resource_json][:resource], params[:studyhub_resource][:resource_json][:study_design] = parse_custom_metadata_attributes(sr)
    # parse resource information and study design

    rt = StudyhubResourceType.where(key: params[:studyhub_resource][:studyhub_resource_type]).first
    params[:studyhub_resource][:studyhub_resource_type_id] = rt.id unless rt.nil?

    params.require(:studyhub_resource).permit(:studyhub_resource_type_id, :comment, { resource_json: {} }, \
                                            :nfdi_person_in_charge, :contact_stage, :data_source,{ project_ids: [] }, \
                                            :comment, :exclusion_mica_reason, :exclusion_seek_reason, \
                                            :exclusion_studyhub_reason, :inclusion_studyhub, :inclusion_seek, \
                                            :inclusion_mica)
  end

  def parse_custom_metadata_attributes(params)
    unless params[:custom_metadata_attributes].nil?


      resource_attributes = %w[resource_type_general resource_language resource_use_rights resource_web_page resource_web_studyhub resource_web_seek resource_web_mica acronym]
      study_design_attributes = %w[study_primary_design study_type_interventional study_type_non_interventional study_type_description
                                 study_primary_purpose study_conditions study_conditions_code study_keywords study_centers study_subject study_region study_target_sample_size
                                 study_obtained_sample_size study_age_min study_age_max study_sex study_inclusion_criteria study_exclusion_criteria study_population study_sampling
                                 study_hypothesis study_design_comment study_IPD_sharing_plan_generally study_IPD_sharing_plan_description
                                 stuy_IPD_sharing_plan_time_frame stuy_IPD_sharing_plan_access_criteria
                                 stuy_IPD_sharing_plan_url study_start_date study_end_date study_datasource study_status study_country study_eligibility]

      resource = {}
      study_design = {}

      params[:custom_metadata_attributes][:data].keys.each do |key|
        if resource_attributes.include? key
          resource[key] = params[:custom_metadata_attributes][:data][key]
        elsif study_design_attributes.include? key

          study_design[key] = case key
          when "study_datasource"
            params[:custom_metadata_attributes][:data][key].drop(1)
                              when "study_country"
                                params[:custom_metadata_attributes][:data][key].drop(1)
          else
            params[:custom_metadata_attributes][:data][key]
                              end

        end
      end
      params[:resource_json][:resource] = resource
      params[:resource_json][:study_design] = study_design
    end
    return resource, study_design
  end

  def parse_roles(params)
    roles = []
    params[:role_name].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['role_type'] = params[:role_type][key]
      entry['role_specific_type_sponsor'] = params[:role_specific_type_sponsor][key]
      entry['role_specific_type_funder'] = params[:role_specific_type_funder][key]
      entry['role_name'] = params[:role_name][key]
      entry['role_email'] = params[:role_email][key] #unless params[:role_email][key].blank?
      entry['role_phone'] = params[:role_phone][key] #unless params[:role_phone][key].blank?
      entry['role_affiliation_name'] = params[:role_affiliation_name][key]
      entry['role_affiliation_city'] = params[:role_affiliation_city][key]
      entry['role_affiliation_zip'] = params[:role_affiliation_zip][key]
      entry['role_affiliation_country'] = params[:role_affiliation_country][key]
      entry['role_affiliation_url'] = params[:role_affiliation_url][key]
      roles << entry unless entry['role_name'].blank?

    end
    roles
  end

  def parse_ids(params)
    ids = []
    params[:id_type].keys.each do |key|
      entry = {}
      next if key == 'row-template'

      entry['id_type'] = params[:id_type][key]
      entry['id_id'] = params[:id_id][key]
      entry['id_date'] = params[:id_date][key]
      entry['id_relation_type'] = params[:id_relation_type][key]
      ids << entry unless entry['id_id'].blank?
    end
    ids
  end

  def parse_resource_descriptions(params)
    resource_descriptions = []
    params[:description_text].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['description_text'] = params[:description_text][key]
      entry['description_language'] = params[:description_language][key]
      resource_descriptions << entry unless entry['description_text'].blank?
    end
    resource_descriptions
  end

  def parse_resource_titles(params)
    resource_titles = []
    params[:resource_title].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['title'] = params[:resource_title][key]
      entry['resource_language'] = params[:resource_language][key]
      resource_titles << entry unless entry['title'].blank?

    end
    resource_titles
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
                         "detail": 'You are not authorized to perform this action.' },
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