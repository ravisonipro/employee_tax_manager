class Employee < ApplicationRecord
  validates :employee_id, :first_name, :last_name, :email, :phone_numbers, :date_of_joining, :salary, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :phone_numbers_format

  def tax_deduction_for_current_year
    current_year = Date.today.year
    financial_year_start = Date.new(current_year, 4, 1)

    total_salary = calculate_total_salary(financial_year_start)

    taxable_income = [total_salary - 250000, 0].max
    tax = calculate_income_tax(taxable_income)
    cess = calculate_cess(tax)

    {
      employee_code: employee_id,
      first_name: first_name,
      last_name: last_name,
      yearly_salary: total_salary.round(2),
      tax_amount: tax.round(2),
      cess_amount: cess.round(2)
    }
  end

  private

  def calculate_total_salary(financial_year_start)
    current_year = Date.today.year
    if Date.today < Date.new(current_year, 3, 31)
      previous_year = current_year - 1
      financial_year_start = Date.new(previous_year, 4, 1) # Financial year starts on April 1st of the previous year
    end

    financial_year_end = Date.new(current_year, 3, 31) # Financial year ends on March 31st of the current year
    doj = date_of_joining

    # Check if employee joined after the financial year start or if they haven't joined yet
    return 0 if doj.nil? || doj > financial_year_end

    start_date = [doj, financial_year_start].max
    end_date = [Date.today, financial_year_end].min

    months_worked = calculate_worked_months(doj)

    total_salary = salary.to_f * months_worked
    total_salary
  end


  def calculate_worked_months(joining_date)
    current_year = Date.today.year
    financial_year_start = Date.new(current_year - (Date.today.month < 4 ? 1 : 0), 4, 1)
    financial_year_end = Date.new(current_year + (Date.today.month >= 4 ? 1 : 0), 3, 31)
   
    if joining_date >= financial_year_start && joining_date <= financial_year_end
      # If joining date is within the current financial year
      return (financial_year_end - joining_date + 1).to_f / 30.44
    elsif joining_date < financial_year_start
      # If joining date is before the start of the financial year
      return 365 / 30
    else
      # If joining date is after the end of the financial year
      return 0
    end
  end

  def calculate_income_tax(taxable_income)
    case taxable_income
    when 0..250000
      0
    when 250001..500000
      (taxable_income - 250000) * 0.05
    when 500001..1000000
      12500 + (taxable_income - 500000) * 0.1
    else
      (taxable_income - 1000000) * 0.2 + 112500
    end
  end

  def calculate_cess(tax)
    tax > 0.025 * 2500000 ? tax * 0.02 : 0
  end

  def valid_salary
    errors.add(:salary, "should be a positive number") unless salary.present? && salary.positive?
  end
end
