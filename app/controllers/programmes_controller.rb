class ProgrammesController < ApplicationController
  include Seek::IndexPager
  include Seek::DestroyHandling

  before_filter :programmes_enabled?
  before_filter :login_required, except: [:show, :index]
  before_filter :find_and_authorize_requested_item, only: [:edit, :update, :destroy]
  before_filter :find_requested_item, only: [:show, :admin, :initiate_spawn_project, :spawn_project,:activation_review,:accept_activation,:reject_activation,:reject_activation_confirmation]
  before_filter :find_assets, only: [:index]
  before_filter :is_user_admin_auth, only: [:initiate_spawn_project, :spawn_project,:activation_review, :accept_activation,:reject_activation,:reject_activation_confirmation]
  before_filter :can_activate?, only: [:activation_review, :accept_activation,:reject_activation,:reject_activation_confirmation]

  skip_before_filter :project_membership_required

  include Seek::BreadCrumbs

  respond_to :html

  def create
    handle_administrators if params[:programme][:administrator_ids]
    @programme = Programme.new(params[:programme])

    if @programme.save
      flash[:notice] = "The #{t('programme').capitalize} was successfully created."

      # current person becomes the programme administrator, unless they are logged in
      # also activation email is sent
      unless User.admin_logged_in?
        User.current_user.person.is_programme_administrator = true, @programme
        if Seek::Config.email_enabled
          Mailer.programme_activation_required(@programme,User.current_user.person).deliver
        end
      end
      disable_authorization_checks { User.current_user.person.save! }
    end

    respond_with(@programme)
  end

  def update
    handle_administrators if params[:programme][:administrator_ids]
    flash[:notice] = "The #{t('programme').capitalize} was successfully updated." if @programme.update_attributes(params[:programme])
    respond_with(@programme)
  end

  def handle_administrators
    params[:programme][:administrator_ids] = params[:programme][:administrator_ids].split(',')
    # if the current person is the administrator, but not a system admin, they need to be added - they cannot remove themself.
    if @programme && !User.admin_logged_in? && User.current_user.person.is_programme_administrator?(@programme)
      params[:programme][:administrator_ids] << User.current_user.person.id.to_s
    end
  end

  def edit
    respond_with(@programme)
  end

  def new
    @programme = Programme.new
    respond_with(@programme)
  end

  def show
    respond_with(@programme)
  end

  def initiate_spawn_project
    @available_projects = Project.where('programme_id != ? OR programme_id IS NULL', @programme.id)
    respond_with(@programme, @available_projects)
  end

  def spawn_project
    proj_params = params[:project]
    @ancestor_project = Project.find(proj_params[:ancestor_id])
    @project = @ancestor_project.spawn(title: proj_params[:title], description: proj_params[:description], web_page: proj_params[:web_page], programme_id: @programme.id)
    if @project.save
      flash[:notice] = "The #{t('project')} '#{@ancestor_project.title}' was successfully spawned for the '#{t('programme')}' #{@programme.title}"
      redirect_to project_path(@project)
    else
      @available_projects = Project.where('programme_id != ? OR programme_id IS NULL', @programme.id)
      render action: :initiate_spawn_project
    end
  end

  def accept_activation
    @programme.activate
    flash[:notice]="The #{t('programme')} has been activated"
    Mailer.programme_activated(@programme).deliver if Seek::Config.email_enabled
    redirect_to @programme
  end

  def reject_activation
    flash[:notice]="The #{t('programme')} has been rejected"
    Mailer.programme_rejected(@programme,@programme.activation_rejection_reason).deliver if Seek::Config.email_enabled
    redirect_to @programme
  end

  private

  def can_activate?
    unless result=@programme.can_activate?
      error("The #{t('programme')} activation status cannot be changed. Maybe it is already activated or you are not an administrator", "cannot activate (not admin or already activated)")
    end
    result
  end

end
