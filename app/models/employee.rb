class Employee < ApplicationRecord
	validates :first_name, :last_name, :email, :phone_number, :date_of_joining, :salary, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :salary, numericality: { greater_than: 0 }

  def tax_deduction_for_current_year

  end

end
