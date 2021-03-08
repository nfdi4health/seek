class StudyhubResourcesController < ApplicationController

  include Seek::AssetsCommon

  api_actions :index, :show

  def index
    @studyhub_resources = StudyhubResource.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml
      format.json { render json: @studyhub_resources }
    end
  end

  def show
    @studyhub_resource = StudyhubResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml
      format.json { render json: @studyhub_resource }
    end
  end

  def create

    @resource = StudyhubResource.new(studyhub_resource_params)
    resource_type = @resource.resource_type.downcase

    item = nil
    if [StudyhubResource::STUDY, StudyhubResource::SUBSTUDY].include? resource_type
      Rails.logger.info('creating a SEEK Study')
      item = @resource.build_study(study_params)
    elsif [StudyhubResource::DOCUMENT, StudyhubResource::INSTRUMENT].include? resource_type
      Rails.logger.info('creating a SEEK Assay')
      item = @resource.build_assay(assay_params)
    end

    update_sharing_policies item

    if @resource.save
      render json: @resource, status: :created, location: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  def handle_create_studyhub_resource_failure
    Rails.logger.info("create seek resource failure!")
    render json: @resource.errors, status: :unprocessable_entity
  end

  def studyhub_resource_params
    params.require(:studyhub_resource).permit(:parent_id, :resource_id, :resource_type, { resource_json: {} })
  end

  def study_params
    investigation_id = params[:studyhub_resource][:investigation_id]
    resource_json = studyhub_resource_params["resource_json"]
    title = resource_json["titles"].first["title"]
    description = resource_json["descriptions"].first["text"] unless resource_json["descriptions"].blank?
    return {
      title: title,
      description: description,
      investigation_id: investigation_id
    }
  end

  def assay_params

    study_id = params[:studyhub_resource][:study_id]
    # search for its parent study if no study id in post request
    if study_id.nil?
      study_id = StudyhubResource.where(resource_id: studyhub_resource_params["parent_id"]).first.study.id
    end

    #ToDo  assign assay without parent to a default study. remove the hard code.
    another_study_id = "3"
    study_id = another_study_id if study_id.nil?

    resource_json = studyhub_resource_params["resource_json"]
    title = resource_json["titles"].first["title"]
    description = resource_json["descriptions"].first["text"] unless resource_json["descriptions"].blank?
    return {
      # currently the assay class is set as modelling type by default
      assay_class_id: AssayClass.for_type("modelling").id,
      title: title,
      description: description,
      study_id: study_id
    }
  end
end