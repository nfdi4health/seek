class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon
  include Seek::DestroyHandling
  include Seek::IndexPager
  include Seek::Publishing::PublishingCommon

  before_action :find_and_authorize_requested_item, only: %i[edit update destroy manage manage_update show download create_content_blob]

  before_action :find_assets, only: [:index]
  before_action :login_required, only: [:create, :create_content_blob, :new_resource]
  api_actions :index, :show, :create, :update, :destroy

  def show
    respond_to do |format|
      format.html
      format.json { render json: @studyhub_resource }
    end
  end

  def download
    @studyhub_resource.just_used
    download_single(@studyhub_resource.content_blob)
  end

  def new_resource

    type = StudyhubResourceType.where(key: params[:studyhub_resource][:studyhub_resource_type]).first
    @studyhub_resource=StudyhubResource.new
    @studyhub_resource.studyhub_resource_type = type
    respond_to do |format|

      format.html do

        if type.is_studytype?
          render template: 'studyhub_resources/new_study', locals: { sr_type: type }
        else
          render template: 'studyhub_resources/upload_file', locals: { sr_type: type }
        end

      end
    end
  end

  def clear_session_info
    session.delete(:uploaded_content_blob_id)
  end

  def create_content_blob
    clear_session_info
    @studyhub_resource = StudyhubResource.new(studyhub_resource_type_params)

    type =  @studyhub_resource.studyhub_resource_type
    respond_to do |format|
      if handle_upload_data && @studyhub_resource.content_blob.save
        session[:uploaded_content_blob_id] = @studyhub_resource.content_blob.id
        format.html { render template: 'studyhub_resources/new_nonstudy', locals: { sr_type: type }}
      else
        session.delete(:uploaded_content_blob_id)
        format.html { render template: 'studyhub_resources/upload_file', status: :unprocessable_entity }
      end
    end
  end

  def create

    @studyhub_resource = StudyhubResource.new(studyhub_resource_params)
    type =  @studyhub_resource.studyhub_resource_type
    update_sharing_policies @studyhub_resource

    if type.is_studytype?
      respond_to do |format|
        if @studyhub_resource.save
          flash[:notice] = "The metadata of #{@studyhub_resource.studyhub_resource_type.title.downcase} was successfully saved.<br/>".html_safe
          flash[:notice] += get_submit_notice if request_to_submit?
          format.html { redirect_to studyhub_resource_path(@studyhub_resource)}
          format.json  { render json: @studyhub_resource, status: :created, location: @studyhub_resource }
        else
          flash.now[:error] = @studyhub_resource.errors.messages[:base].join('<br/>').html_safe
          format.html {render template: 'studyhub_resources/new_study', locals: { sr_type: type },status: :unprocessable_entity}
          format.json {render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity}
        end
      end
    else

      # check the content blob id matches that previously uploaded and recorded on the session
      uploaded_blob_matches = (params[:content_blob_id].to_s == session[:uploaded_content_blob_id].to_s)
      @studyhub_resource.errors.add(:base, "The file uploaded doesn't match") unless uploaded_blob_matches

      blob = ContentBlob.find(params[:content_blob_id])
      @studyhub_resource.content_blob = blob

      respond_to do |format|
        if uploaded_blob_matches && @studyhub_resource.save && blob.save
          clear_session_info

          flash[:notice] = "#{type.title.downcase} was successfully uploaded and saved." if flash.now[:notice].nil?
          format.html {redirect_to studyhub_resource_path(@studyhub_resource)}
          format.json  {render json: @studyhub_resource, status: :created, location: @studyhub_resource}

        else
          flash.now[:error] = @studyhub_resource.errors.messages[:base].join('<br/>').html_safe
          format.html { render template: 'studyhub_resources/new_nonstudy', locals: { sr_type: type }, status: :unprocessable_entity}
        end
      end
    end
  end


  def edit
    @studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end



  def upload_file
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

    respond_to do |format|

      if @studyhub_resource.save
        flash[:notice] = "The metadata of #{@studyhub_resource.studyhub_resource_type.title.downcase} was successfully updated.<br/>".html_safe
        flash[:notice] += get_submit_notice if request_to_submit?

        if @studyhub_resource.is_studytype? || !@studyhub_resource.content_blob.nil?
          format.html { redirect_to studyhub_resource_path(@studyhub_resource) }
        else
          flash[:notice] += "You can now upload a file for it".html_safe
          format.html { render action: 'upload_file' }
        end
        format.json { render json: @studyhub_resource, status: 200 }

      else
        flash.now[:error] = @studyhub_resource.errors.messages[:base].join('<br/>').html_safe
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


  def request_to_submit?
    (params[:studyhub_resource][:commit_button] == 'Submit') ? true : false
  end

  def get_submit_notice
    html = "<div class='alert submit-info'>
              By clicking on the button “Submit”, you confirm the correctness of the data entered and apply for registration of your resource in the NFDI4Health Task Force COVID-19 system.
              <br/>
              Please note, after the form is submitted successfully, your data is still private.
              You can send a request to publish your data. Your request will be reviewed by our "+ t('studyhub_resources.gatekeep')+".
              If the data have been entered correctly, your application will be approved and the resource will be published.
              <br/>
              </div>"
    html.html_safe
  end


  def studyhub_resource_documents_params
    params.require(:studyhub_resource).permit( { document_ids: [] })
  end


  def studyhub_resource_projects_params
    params.require(:studyhub_resource).permit( { project_ids: [] })
  end

  def studyhub_resource_type_params
    @rt = StudyhubResourceType.where(key: params[:studyhub_resource][:studyhub_resource_type]).first
    params[:studyhub_resource][:studyhub_resource_type_id] = @rt.id unless @rt.nil?
    params.require(:studyhub_resource).permit(:studyhub_resource_type_id)
  end


  def studyhub_resource_params

    @rt = StudyhubResourceType.where(key: params[:studyhub_resource][:studyhub_resource_type]).first
    params[:studyhub_resource][:studyhub_resource_type_id] = @rt.id unless @rt.nil?
    sr = params[:studyhub_resource]
    params[:studyhub_resource][:resource_json] = {}

    # parse titles
    sr[:title] = sr[:resource_title].values[0] unless sr[:resource_title].nil?

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
                                            :inclusion_mica, :commit_button)
  end


  def  get_custom_metadata_attributes(title)
    CustomMetadataType.where(title:title).first.custom_metadata_attributes.map(&:title)
  end

  def parse_custom_metadata_attributes(params)

    cm_resource_attributes = get_custom_metadata_attributes('NFDI4Health Studyhub Resource General')
    cm_study_design_attributes = get_study_design_attributes(params)

    unless params[:custom_metadata_attributes].nil?

      resource = {}
      study_design = {}

      params[:custom_metadata_attributes][:data].keys.each do |key|
        value = if StudyhubResource::MULTISELECT_ATTRIBUTES.include? key
          params[:custom_metadata_attributes][:data][key].reject{|x| x.blank?}
        else
          params[:custom_metadata_attributes][:data][key]
                end

        if cm_resource_attributes.include? key
          resource[key] = value
        elsif cm_study_design_attributes.include? key
          study_design[key] = value
        end
      end

      params[:resource_json][:resource] = resource
      params[:resource_json][:study_design] = study_design if @rt.is_studytype?

    end
    return resource, study_design
  end

  def get_study_design_attributes(params)

    cm_study_design_general_attributes = get_custom_metadata_attributes('NFDI4Health Studyhub Resource StudyDesign General')
    cm_study_design_non_interventional_attributes = get_custom_metadata_attributes('NFDI4Health Studyhub Resource StudyDesign Non Interventional Study')
    cm_study_design_interventional_attributes = get_custom_metadata_attributes('NFDI4Health Studyhub Resource StudyDesign Interventional Study')

    cm_study_design_attributes = cm_study_design_general_attributes
    case params[:custom_metadata_attributes][:data]['study_primary_design']
    when StudyhubResource::INTERVENTIONAL
      cm_study_design_attributes += cm_study_design_interventional_attributes
    when StudyhubResource::NON_INTERVENTIONAL
      cm_study_design_attributes += cm_study_design_non_interventional_attributes
    end
    cm_study_design_attributes
  end

  def parse_roles(params)
    roles = []
    params[:role_type].keys.each do |key|

      next if key == 'row-template'
      entry = {}

      entry['role_type'] = params[:role_type][key]
      entry['role_name_type'] = params[:role_name_type][key]


      case entry['role_name_type']
      when 'Organisational'
        entry['role_name_organisational'] = params[:role_name_organisational][key]
      when 'Personal'
        entry['role_name_personal_title'] = params[:role_name_personal_title][key]
        entry['role_name_personal_given_name'] = params[:role_name_personal_given_name][key]
        entry['role_name_personal_family_name'] = params[:role_name_personal_family_name][key]
      end

      entry['role_name_identifier'] = params[:role_name_identifier][key]
      entry['role_name_identifier_scheme'] = params[:role_name_identifier_scheme][key]
      entry['role_email'] = params[:role_email][key]
      entry['role_phone'] = params[:role_phone][key]
      entry['role_affiliation_name'] = params[:role_affiliation_name][key]
      entry['role_affiliation_address'] = params[:role_affiliation_address][key]
      entry['role_affiliation_web_page'] = params[:role_affiliation_web_page][key]
      entry['role_affiliation_identifier'] = params[:role_affiliation_identifier][key]
      entry['role_affiliation_identifier_scheme'] = params[:role_affiliation_identifier_scheme][key]

      roles << entry unless entry['role_type'].blank?

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
      entry['id_resource_type_general'] = params[:id_resource_type_general][key]
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

end