# frozen_string_literal: true

class Employee < ApplicationRecord
  belongs_to :account
  belongs_to :company
  has_many :events

  validates :start_day, presence: true
  validates :is_enabled, presence: true
end
