class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon
  before_action :find_and_authorize_requested_item, only: %i[edit update destroy manage show]
  api_actions :index, :show, :create, :update, :destroy

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

    #todo only save @studyhub_resource when item(study/assay) is created successfully
    if item.valid?
      if @studyhub_resource.save
        update_parent_child_relationships(relationship_params)
        render json: @studyhub_resource, status: :created, location: @studyhub_resource
      else
        render json: @studyhub_resource.errors, status: :unprocessable_entity
      end
    else
      render json: item.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /studyhub_resources/1
  def update
    @studyhub_resource.update(studyhub_resource_params)
    # update_sharing_policies @studyhub_resource
    update_parent_child_relationships(relationship_params)

    respond_to do |format|
      if @studyhub_resource.save
        format.json {render json: @studyhub_resource, status: 200}
      else
        format.json { render json: json_api_errors(@studyhub_resource), status: :unprocessable_entity }
      end
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

  private

  def study_params
    investigation_id = params[:studyhub_resource][:investigation_id]
    resource_json = studyhub_resource_params['resource_json']
    title = resource_json['titles'].first['title']
    description = resource_json['descriptions'].first['text'] unless resource_json['descriptions'].blank?

    cmt, metadata = extract_custom_metadata('study')

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

    #ToDo assign assay without parent to a default study. remove the hard code.
    other_studyhub_resource_id = Seek::Config.nfdi_other_studyhub_resource_id

    # if resource has no parents, assign it to "other studies"s
    if relationship_params["parent_ids"].blank?
      study_id = other_studyhub_resource_id
    else

      parent = StudyhubResource.where(id: relationship_params["parent_ids"]).first

      # TODO: when parents are other types, such as "instrument", "document"
      # TODO: if parent doesnt exist, still need to sort out the relationship
      study_id = if !parent.nil? && ([StudyhubResource::STUDY,
                                      StudyhubResource::SUBSTUDY].include? parent.resource_type)
                   parent.study.id
                 else
                   other_studyhub_resource_id
                 end
    end

    resource_json = studyhub_resource_params['resource_json']
    title = resource_json['titles'].first['title']
    description = resource_json['descriptions'].first['text'] unless resource_json['descriptions'].blank?

    cmt, metadata = extract_custom_metadata('assay')

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
    params.require(:studyhub_resource).permit(:resource_type, :comment, { resource_json: {} }, \
                                              :nfdi_person_in_charge, :contact_stage, :data_source, \
                                              :comment, :exclusion_mica_reason, :exclusion_seek_reason, \
                                              :exclusion_studyhub_reason, :inclusion_studyhub, :inclusion_seek, \
                                              :inclusion_mica)
  end

  def relationship_params
    params.require(:studyhub_resource).permit(parent_ids: [], child_ids: [])
  end

  def map_to_seek_type(resource_type)
    if [StudyhubResource::STUDY, StudyhubResource::SUBSTUDY].include? resource_type.downcase
      'Study'
    elsif [StudyhubResource::DOCUMENT, StudyhubResource::INSTRUMENT].include? resource_type.downcase
      'Assay'
    end
  end

  def extract_custom_metadata(resource_type)
    if CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata', supported_type: resource_type).any?
      cmt = CustomMetadataType.where(title: 'NFDI4Health Studyhub Resource Metadata',
                                     supported_type: resource_type).first
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

  def update_parent_child_relationships(params)

    if params.key?(:parent_ids)
      params["parent_ids"].each do |x|
        parent = StudyhubResource.find(x)
        if parent.nil?
          pp 'Studyhub Resource id #{x} doesnt exist'
        else
          @studyhub_resource.add_parent(parent)
        end
      end
    end

    if params.key?(:child_ids)
      params["child_ids"].each do |x|
        child = StudyhubResource.find(x)
        if child.nil?
          pp 'Studyhub Resource id #{x} doesnt exist'
        else
          @studyhub_resource.add_child(child)
        end
      end
    end
  end

end