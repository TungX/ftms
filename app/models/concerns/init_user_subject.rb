module InitUserSubject
  def create_user_subjects user_courses, course_subjects, course_id, condition
    unless condition
      user_courses.each do |user_course|
        unless user_course.supervisor_id?
          course_subjects.each do |course_subject|
            user_course.user_subjects.create course_id: course_id,
              user_id: user_course.user_id,
              course_subject_id: course_subject.id
          end
        end
      end
    end
  end
end
