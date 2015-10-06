class Subject < ActiveRecord::Base
  include RailsAdminSubject

  has_many :task_masters, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :task_masters, allow_destroy: true,
    reject_if: proc {|attributes| attributes["name"].blank?}
end
