# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :authenticate_account!
  load_and_authorize_resource

  # GET /companies/1
  def show
    @employees = @company.employees.joins(:account).eager_load(:account)
  end

  # GET /companies/new
  def new
    @new_company = Company.new
  end

  # GET /companies/1/edit
  def edit; end

  # POST /companies
  def create
    result = Companies::Create.new.call(company_params, current_account.id)
    @company = result.value
    if result.success?
      session[:current_company_id] = @company.id
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    if @company.destroy
      flash[:notice] = 'You have successfully delete company.'
      session.delete(:current_company_id)
    else
      flash[:error] = "Company can't be deleted"
    end
    redirect_to root_path
  end

  def calendar
    @calendar = Companies::CalendarPresenter.new(@company, current_account.id, params)
  end

  def switch
    session[:current_company_id] = @company&.id
    smart_redirect
  end

  def invites
    @invites = @company.employees.where(account_id: nil).eager_load(:account)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name)
  end

  def smart_redirect
    uri = URI(request.referrer.to_s)

    if uri.path =~ /\d/ || uri.query =~ /\d/
      redirect_to(root_path)
    else
      redirect_back(fallback_location: calendar_path)
    end
  end
end
