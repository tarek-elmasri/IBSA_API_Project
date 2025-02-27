class Api::V1::MarketingManagersController < ApplicationController

  before_action :Authenticate_user
  before_action :Classify_user
  before_action :Authorize_user

  def create_par
    par= Par.new(cs_params)
    par.status='pending'
    par.employer_id = @classified_user.employer_id
    manager= CsManager.find_by(id: @classified_user.cs_manager_id)
    par.charged_person = manager.employer_id

    if par.save
      render json: {par: par},status: :created
    else
      render json: {errors: par.errors},status: :unprocessable_entity
    end
  end


  def my_pars
    pars=Par.where(employer_id: @classified_user.employer_id)
    render json: {pars: pars},status: :ok
  end

  def my_pending_pars
    pars=Par.where(employer_id: @classified_user.employer_id , status:'pending')
    render json: {pars: pars},status: :ok
  end

  def approval_list
    pars= Par.where(charged_person: @current_user.id)
    render json: {pars: pars},status: :ok
  end

  
  private
  def cs_params
    params.permit(:par_type , :description , :value , :client_id , :client_name)
  end

  
  private
  def Authorize_user 
    render json: {errors: ['un Authorized User']},status: :unauthorized unless @current_user.role=='MM'
  end
end
