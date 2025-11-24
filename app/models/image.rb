require "rmagick"
require "descriptive_statistics"

class Image < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 150, 150 ], preprocessed: true
    attachable.variant :big, resize: "75%", preprocessed: true
    attachable.variant :medium, resize: "50%", preprocessed: true
    attachable.variant :small, resize: "25%", preprocessed: true
    attachable.variant :webp, convert: "webp", quality: 80, preprocessed: true
    attachable.variant :flipped_vertical, append: "-flip", preprocessed: true
    attachable.variant :grayscale, colorspace: "Gray", preprocessed: true
  end

  has_one_attached :historygram

  after_save :set_historygram

  private

  def set_historygram
    HistorygramJob.perform_later(self)
  end
end
