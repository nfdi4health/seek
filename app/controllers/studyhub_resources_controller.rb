class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon
  include Seek::DestroyHandling
  include Seek::IndexPager
  include Seek::Publishing::PublishingCommon

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

  def associate_documents
    @studyhub_resource = StudyhubResource.find(params[:id])
    @document = Document.new
  end

  def associate_existing_documents
    @studyhub_resource = StudyhubResource.find(params[:id])
    @studyhub_resource.update(studyhub_resource_documents_params)

    respond_to do | format |
      if  @studyhub_resource.save
        flash.now[:notice] = "The document is associated with #{t('studyhub_resource')} successfully." if flash.now[:notice].nil?
        format.html { redirect_to @studyhub_resource }
        format.json { render json: @studyhub_resource }
      end
    end
  end


  def associate_new_document

    @studyhub_resource = StudyhubResource.find(params[:id])
    @document = Document.new(
      title: @studyhub_resource.title,
      description: @studyhub_resource.description,
      project_ids: @studyhub_resource.projects.map(&:id)
      # policy_attributes: valid_sharing
    )

    @document.policy = @studyhub_resource.policy
    @document.policy.permissions = @studyhub_resource.policy.permissions

    respond_to do |format|
      if handle_upload_data && @document.content_blob.save && @document.save
        @studyhub_resource.documents << @document
        session[:uploaded_content_blob_id] = @document.content_blob.id
        if  @studyhub_resource.save
          flash.now[:notice] = "The document is created and associated with #{t('studyhub_resource')} successfully." if flash.now[:notice].nil?
          format.html { redirect_to @studyhub_resource }
          format.json { render json: @studyhub_resource }
        end
      else
        format.html { render action: :new, status: :unprocessable_entity }
      end
    end

  end

  def create

      @studyhub_resource = StudyhubResource.new(studyhub_resource_params)
      update_sharing_policies @studyhub_resource

      respond_to do |format|
        if @studyhub_resource.save
          flash[:notice] = "#{@studyhub_resource.studyhub_resource_type.title} was successfully created.<br/>".html_safe

          if @studyhub_resource.is_studytype?
            format.html { redirect_to studyhub_resource_path(@studyhub_resource) }
          else
            format.html { redirect_to nonstudy_metadate_saved_studyhub_resource_path(@studyhub_resource)}
          end
          format.json { render json: @studyhub_resource, status: :created, location: @studyhub_resource }
        else
          flash[:error] = @studyhub_resource.errors.messages[:base].join("<br/>").html_safe
          format.html { render action: 'new' }
          format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
        end
      end

      #todo(hu) only save @studyhub_resource when item(study/assay) is created successfully
      #if item.valid?
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

  end


  def edit
    @studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end


  def nonstudy_metadate_saved
    @studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end

  # PUT /studyhub_resources/1
  def update

    @studyhub_resource.update_attributes(studyhub_resource_params)
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

      if @studyhub_resource.save
        flash[:notice] = "#{@studyhub_resource.studyhub_resource_type.title} was successfully updated.<br/>".html_safe
        if @studyhub_resource.is_studytype?
          format.html { redirect_to studyhub_resource_path(@studyhub_resource) }
        else
          format.html { render action: 'nonstudy_metadate_saved' }
        end
        format.json { render json: @studyhub_resource, status: 200 }

      else
        flash[:error] = @studyhub_resource.errors.messages[:base].join("<br/>").html_safe
        format.html { render action: 'edit' }
        format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
      end
    end
  end


  # Patch /studyhub_resources/1
  # handles update for manage properties, the action for the manage form
  def manage_update

    raise 'shouldnt get this far without manage rights' unless @studyhub_resource.can_manage?

    @studyhub_resource.update_attributes(:project_ids => params[:studyhub_resource][:project_ids])
    update_sharing_policies @studyhub_resource
    update_relationships(@studyhub_resource, params)

    respond_to do |format|
      if @studyhub_resource.save!
        flash[:notice] = "#{t('studyhub_resource')} metadata was successfully updated."
        format.html { redirect_to studyhub_resource_path(@studyhub_resource) }
        format.json { render json: @studyhub_resource, status: 200 }
      else
        format.html { render action: 'edit' }
        format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
      end
    end

  end


  def preview_stages

    resource = if params[:id].present?
      StudyhubResource.find(params[:id])
    else
      StudyhubResource.new
               end
    stage_text = StudyhubResource.get_stage_wording(resource.stage)

    respond_to do |format|
      format.html { 
        render partial: 'preview_stages',
               locals: {resource: resource, stage_text: stage_text }}
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
  #   description = resource_json['descriptions'].first['description'] unless resource_json['descriptions'].blank?
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
  #   description = resource_json['descriptions'].first['description'] unless resource_json['descriptions'].blank?
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
  #
  def studyhub_resource_documents_params
    params.require(:studyhub_resource).permit( { document_ids: [] })
  end


  def studyhub_resource_projects_params
    params.require(:studyhub_resource).permit( { project_ids: [] })
  end

  def studyhub_resource_params

    @rt = StudyhubResourceType.where(key: params[:studyhub_resource][:studyhub_resource_type]).first
    params[:studyhub_resource][:studyhub_resource_type_id] = @rt.id unless @rt.nil?

    params[:studyhub_resource][:resource_json] = {}
    sr = params[:studyhub_resource]

    #a flag to send a signal to run a full validations.
    if params[:save_button]
      params[:studyhub_resource][:submit_button_clicked] = false
    else
      params[:studyhub_resource][:submit_button_clicked] = true
    end

    # parse titles
    sr[:title] = sr[:resource_title].values[0]
    sr[:resource_json][:resource_titles] = parse_resource_titles(sr)

    # parse acronyms
    sr[:resource_json][:resource_acronyms] = parse_resource_acronyms(sr)

    # parse descriptions
    sr[:resource_json][:resource_descriptions] = parse_resource_descriptions(sr)


    # parse IDs
    sr[:resource_json][:ids] = parse_ids(sr)


    # parse roles
    sr[:resource_json][:roles] = parse_roles(sr)


    params[:studyhub_resource][:resource_json][:resource], params[:studyhub_resource][:resource_json][:study_design] = parse_custom_metadata_attributes(sr)
    # parse resource information and study design


    unless @rt.is_studytype?
      params[:studyhub_resource][:resource_json] = params[:studyhub_resource][:resource_json].except(:study_design)
    end

    params.require(:studyhub_resource).permit(:title,:studyhub_resource_type_id, :comment, { resource_json: {} }, \
                                            :nfdi_person_in_charge, :contact_stage, :data_source,{ project_ids: [] }, { document_ids: [] },\
                                            :comment, :exclusion_mica_reason, :exclusion_seek_reason, \
                                            :exclusion_studyhub_reason, :inclusion_studyhub, :inclusion_seek, \
                                            :inclusion_mica, :submit_button_clicked)
  end


  def  get_custom_metadata_attributes(title)
    CustomMetadataType.where(title:title).first.custom_metadata_attributes.map(&:title)
  end

  def parse_custom_metadata_attributes(params)

    cm_resource_attributes = get_custom_metadata_attributes("NFDI4Health Studyhub Resource General")
    cm_study_design_attributes = get_study_design_attributes(params)

    multselect_attributes = %w[study_datasource study_country study_data_sharing_plan_supporting_information study_gender study_masking_roles]

    unless params[:custom_metadata_attributes].nil?

      resource = {}
      study_design = {}

      params[:custom_metadata_attributes][:data].keys.each do |key|
        if cm_resource_attributes.include? key
          resource[key] = params[:custom_metadata_attributes][:data][key]
        elsif cm_study_design_attributes.include? key
          study_design[key] = if multselect_attributes.include? key
                                params[:custom_metadata_attributes][:data][key].reject{|x| x.blank?}
                              else
                                params[:custom_metadata_attributes][:data][key]
                              end
        end
      end

      params[:resource_json][:resource] = resource

      if @rt.is_studytype?
        study_design = set_study_data_sharing_plan(study_design)
        params[:resource_json][:study_design] = study_design
      end

    end
    return resource, study_design
  end

  def get_study_design_attributes(params)

    cm_study_design_general_attributes = get_custom_metadata_attributes("NFDI4Health Studyhub Resource StudyDesign General")
    cm_study_design_non_interventional_attributes = get_custom_metadata_attributes("NFDI4Health Studyhub Resource StudyDesign Non Interventional Study")
    cm_study_design_interventional_attributes = get_custom_metadata_attributes("NFDI4Health Studyhub Resource StudyDesign Interventional Study")

    cm_study_design_attributes = cm_study_design_general_attributes
    if params[:custom_metadata_attributes][:data]["study_primary_design"] == "interventional"
      cm_study_design_attributes += cm_study_design_interventional_attributes
    elsif params[:custom_metadata_attributes][:data]["study_primary_design"] == "non-interventional"
      cm_study_design_attributes += cm_study_design_non_interventional_attributes
    end
    cm_study_design_attributes
  end

  def set_study_data_sharing_plan(study_design)
    unless study_design["study_data_sharing_plan_generally"].start_with?("Yes")
      study_design["study_data_sharing_plan_supporting_information"] = []
      study_design["study_data_sharing_plan_time_frame"] = ""
      study_design["study_data_sharing_plan_access_criteria"] = ""
      study_design["study_data_sharing_plan_url"] = ""
    end
    study_design
  end

  def parse_roles(params)
    roles = []
    params[:role_name].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['role_type'] = params[:role_type][key]
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

  def parse_resource_titles(params)
    resource_titles = []
    params[:resource_title].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['title'] = params[:resource_title][key]

      entry['title_language'] = params[:title_language][key]
      resource_titles << entry unless entry['title'].blank?

    end
    resource_titles
  end

  def parse_resource_acronyms(params)
    resource_acronyms = []
    params[:resource_acronym].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['acronym'] = params[:resource_acronym][key]

      entry['acronym_language'] = params[:acronym_language][key]
      resource_acronyms << entry unless entry['acronym'].blank?

    end
    resource_acronyms
  end

  def parse_resource_descriptions(params)
    resource_descriptions = []
    params[:description].keys.each do |key|
      next if key == 'row-template'

      entry = {}
      entry['description'] = params[:description][key]

      entry['description_language'] = params[:description_language][key]
      resource_descriptions << entry unless entry['description'].blank?
    end
    resource_descriptions
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

  def update_documents_assoication(resource,params)
    ss
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