class StudyhubResourcesController < ApplicationController

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

    @resource = StudyhubResource.new(studyhub_resource_params)

    if @resource.save
      render json: @resource, status: :created, location: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end

  end



  def studyhub_resource_params
    params.require(:studyhub_resource).permit(:parent_id,:resource_id,:resource_type, {resource_json: {}})
  end


end