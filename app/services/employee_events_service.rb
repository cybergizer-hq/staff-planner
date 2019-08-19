# frozen_string_literal: true

class EmployeeEventsService
  attr_reader :employee, :events_dates

  def initialize(event_params, day)
    @employee = employee
    @events_dates = if event_params[:start_period].present?
                      employee.events
                              .where('start_period >= ? AND end_period <= ?',
                                     event_params[:start_period], event_params[:end_period])
                    else
                      employee.events.where('start_period <= ? AND end_period >= ?', day, day)
                    end
  end

  def events
    events_dates.group_by(&:start_date)
    end
  end
end
