class CourseSubject < ActiveRecord::Base
  include PublicActivity::Model
  include RailsAdminCourseSubject
  include InitUserSubject

  after_create :create_user_subjects_when_add_new_subject

  tracked only: [:create, :destroy],
    owner: ->(controller, model) {controller.current_user},
    recipient: ->(controller, model) {model && model.course},
    params: {
      subject: proc {|controller, model| model.subject}
    }

  belongs_to :subject
  belongs_to :course
  has_many :user_subjects, dependent: :destroy

  enum status: [:init, :progress, :finish]

  private
  def create_user_subjects_when_add_new_subject
    create_user_subjects course.user_courses, [self], course_id, course.init?
  end
end
