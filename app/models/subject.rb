class Subject < ActiveRecord::Base
  include RailsAdminSubject

  has_many :task_masters, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects

  validates :name, presence: true, uniqueness: true

  scope :subject_not_start_course, ->course{where "id NOT IN (SELECT subject_id
    FROM course_subjects WHERE course_id = ? AND status <> 0)", course.id}

  accepts_nested_attributes_for :task_masters, allow_destroy: true,
    reject_if: proc {|attributes| attributes["name"].blank?}

  scope :subject_all, ->(course_id){}
  scope :subject_in, ->(course_id){joins(:course_subjects).where(course_subjects:
    {course_id: course_id})}
  scope :subject_out, ->(course_id){where "id NOT IN (SELECT subject_id
    FROM course_subjects WHERE course_id <> #{course_id})"}
end
