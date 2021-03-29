class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon
  before_action :find_resource, only: %i[show update destroy]
  api_actions :index, :show

  def index

    resources_expr = "StudyhubResource.all"
    resources_expr << ".where(resource_type: params[:type])" if params[:type].present?
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
      format.html # show.html.erb
      format.xml
      format.json { render json: @studyhub_resources }
    end
  end

  def show
    #@studyhub_resource = StudyhubResource.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml
      format.json { render json: @studyhub_resource }
    end
  end

  def create
    @studyhub_resource = StudyhubResource.new(studyhub_resource_params)
    resource_type = @studyhub_resource.resource_type
    seek_type = map_to_seek_type(resource_type)

    item = nil

    case seek_type
    when 'Study'
      Rails.logger.info('creating a SEEK Study')
      item = @studyhub_resource.build_study(study_params)
      #item.valid?
      #pp item.errors.full_messages
    when 'Assay'
      Rails.logger.info('creating a SEEK Assay')
      item = @studyhub_resource.build_assay(assay_params)
      # item.valid?
      # pp item.errors.full_messages
    end

    update_sharing_policies item

    if @studyhub_resource.save

      render json: @studyhub_resource, status: :created, location: @studyhub_resource
    else
      render json: @studyhub_resource.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /studyhub_resources/1
  def update
    if @studyhub_resource.update(studyhub_resource_params)
      #render json: @studyhub_resource
      render json: { message: 'resource successfully updated.'}, status: 200
    else
      #render error: { error: 'unable to update studyhub_resource' }, status: 400
      render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity
      #render json: @studyhub_resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE ....studyhub_resources/1
  def destroy
    if @studyhub_resource
      @studyhub_resource.destroy
      render json: { message: 'resource successfully deleted.'}, status: 200
    else
      render json: { error: 'Unable to delete resource'}, status: 400
    end
  end

  def handle_create_studyhub_resource_failure
    Rails.logger.info('create seek resource failure!')
    render json: @studyhub_resource.errors, status: :unprocessable_entity
  end

  private

  def study_params
    investigation_id = params[:studyhub_resource][:investigation_id]
    resource_json = studyhub_resource_params['resource_json']
    title = resource_json['titles'].first['title']
    description = resource_json['descriptions'].first['text'] unless resource_json['descriptions'].blank?

    cmt,metadata = extract_custom_metadata('study')

    {
      title: title,
      description: description,
      investigation_id: investigation_id,
      custom_metadata_attributes: {
        custom_metadata_type_id: cmt.id, data: metadata
      }
    }

  end

  def assay_params

    study_id = nil
    #ToDo  assign assay without parent to a default study. remove the hard code.
    another_study_id = 11

    # if resource has no parents, assign it to "other studies"s
    if studyhub_resource_params["parent_id"].blank?
      study_id = another_study_id
    else

      parent = StudyhubResource.where(id: studyhub_resource_params["parent_id"]).first

      # Todo: when parents are other types, such as "instrument", "document"
      # Todo: if parent doesnt exist, still need to sort out the relationship
      study_id = if !parent.nil? && ([StudyhubResource::STUDY, StudyhubResource::SUBSTUDY].include? parent.resource_type)
                   parent.study.id
                 else
                   another_study_id
                 end
    end

    resource_json = studyhub_resource_params['resource_json']
    title = resource_json['titles'].first['title']
    description = resource_json['descriptions'].first['text'] unless resource_json['descriptions'].blank?

    cmt,metadata = extract_custom_metadata('assay')

    {
      # currently the assay class is set as modelling type by default
      assay_class_id: AssayClass.for_type('modelling').id,
      title: title,
      description: description,
      study_id: study_id,
      custom_metadata_attributes: {
        custom_metadata_type_id: cmt.id, data: metadata
      }
    }
  end

  def studyhub_resource_params
      params.require(:studyhub_resource).permit(:parent_id, :resource_type, :comment, { resource_json: {} }, \
      :NFDI_person_in_charge, :contact_stage, :data_source, \
      :comment, :Exclusion_MICA_reason, :Exclusion_SEEK_reason, \
      :Exclusion_StudyHub_reason, :Inclusion_Studyhub, :Inclusion_SEEK, \
      :Inclusion_MICA)
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_resource
    @studyhub_resource = StudyhubResource.find(params[:id])
  end

  def map_to_seek_type(resource_type)
    if [StudyhubResource::STUDY, StudyhubResource::SUBSTUDY].include? resource_type.downcase
      'Study'
    elsif [StudyhubResource::DOCUMENT, StudyhubResource::INSTRUMENT].include? resource_type.downcase
      'Assay'
    else
      nil
    end
  end

  def extract_custom_metadata(resource_type)

    if CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata',supported_type: resource_type).any?
      cmt = CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata', supported_type: resource_type).first
    end

    resource_json = @studyhub_resource.resource_json

    metadata = {
      "resource_web_studyhub": resource_json['resource_web_studyhub'],
      "resource_type": resource_json['resource_type'].capitalize,
      "resource_web_page": resource_json['resource_web_page'],
      "resource_web_mica": resource_json['resource_web_mica'],
      "acronym": resource_json['acronyms'].first['acronym']
    }

    if resource_json.key? 'study'
      study_start_date = resource_json['study']['study_start_date'].nil? ? nil : Date.strptime(resource_json['study']['study_start_date'], '%Y-%m-%d')
      study_end_date = resource_json['study']['study_end_date'].nil? ? nil : Date.strptime(resource_json['study']['study_end_date'], '%Y-%m-%d')

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

end