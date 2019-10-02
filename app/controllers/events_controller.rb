# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :rules, only: %i[create new]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company, except: :create

  def index
    @employee = Employee.find(params[:employee_id])
    @presenter = Events::IndexPresenter.new(@employee, current_ability, params)
  end

  def show; end

  def new
    @employee = Employee.find_by(account: current_account, company: @company)
    @event = @rules.first&.events&.build
  end

  def edit; end

  def create
    result = Events::Create.new(current_account, params, @company).call
    if result.success?
      redirect_to calendar_path
    else
      render :new
    end
  end

  def update
    result = Events::Update.new.call(@event, params)
    if result.success?
      redirect_to events_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      flash[:notice] = 'You have successfully cancelled your employee.'
    else
      flash[:error] = "Employee account wasn't cancelled."
    end
    redirect_to events_path
  end

  def accept
    event = Event.find(params[:event_id])
    flash[:error] = 'Accept failed' unless event.accept!
    redirect_to calendar_path
  end

  def decline
    event = Event.find(params[:event_id])
    flash[:error] = 'Decline failed' unless event.decline!
    redirect_to calendar_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def rules
    @rules = @company.rules
  end

  def event_params
    params.require(:event).permit(:employee_id)
  end
end
