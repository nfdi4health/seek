class StudyhubResourcesController < ApplicationController

  api_actions :index, :show

  def index
    @studyhub_resources = StudyhubResource.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml
      format.json {render json: @studyhub_resources}
    end
  end

  def show
    @studyhub_resource = StudyhubResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml
      format.json {render json: @studyhub_resource}
    end
  end

  def create

    Rails.logger.info('+++++++++++++++++++++++++')
    Rails.logger.info('studyhub_resource_params:'+studyhub_resource_params.inspect )
    Rails.logger.info('policy_params:'+policy_params.inspect)

    @resource = StudyhubResource.new(studyhub_resource_params)
    resource_type = @resource.resource_type.downcase

    Rails.logger.info('resource_type:'+resource_type.inspect)

    if [StudyhubResource::STUDY,StudyhubResource::SUBSTUDY].include? resource_type
      #item = Study.new(study_params)
      #@resource.study = item
      @resource.build_study(study_params)
    elsif [StudyhubResource::DOCUMENT,StudyhubResource::INSTRUMENT].include? resource_type
      Rails.logger.info('creating a SEEK Assay')
    end
    true


    if @resource.save
      render json: @resource, status: :created, location: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end

  end

  def handle_create_studyhub_resource_failure
    puts 'create_seek_resource_failure!'
    render json: @resource.errors, status: :unprocessable_entity
  end


  def studyhub_resource_params
    params.require(:studyhub_resource).permit(:parent_id,:resource_id,:resource_type, {resource_json: {}})
  end


  def study_params
    return {
      title: "this is a study title",
      description: 'blah blah',
      investigation_id: '1'
    }
  end

end