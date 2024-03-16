class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy]

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # GET /employees/tax_deduction
  def tax_deduction
    employees = Employee.all.map(&:tax_deduction_for_current_year)
    render json: employees
  end

  private

    def employee_params
      params.require(:employee).permit(:employee_id, :first_name, :last_name, :email, :phone_number, :date_of_joining, :salary)
    end
end
