# frozen_string_literal: true

class SlackNotification < ApplicationRecord
  belongs_to :company

  validates :is_enabled, inclusion: { in: [true, false] }
  validates :token, presence: true, if: :is_enabled
end
