module RailsAdmin
  module Config
    module Actions
      class Show < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :route_fragment do
          ''
        end

        register_instance_option :breadcrumb_parent do
          [:index, bindings[:abstract_model]]
        end

        register_instance_option :controller do
          proc do
            case object.class.name
            when "User"
              @object_name = "user"
              @user = object
              if @user_course = @user.user_courses.actived.last
                @user_subjects = @user_course.user_subjects
                @inprogress_course = @user_course.course
                @finished_courses = @user.courses.finish
                @user_subjects.each do |user_subject|
                  user_subject.course_subject.tasks.each do |task|
                    user_subject.user_tasks.find_or_initialize_by task_id: task.id,
                      user_id: @user.id
                  end
                end
              end
            when "Course"
              @object_name = "course"
              @course = object
              @members = object.users
              @course_subjects = @course.course_subjects
              @total_tasks = @course.course_subjects.map(&:tasks).flatten.count
            when "Subject"
              @object_name = "subject"
              @task_masters = object.task_masters
            else
              @object_name = "default"
              respond_to do |format|
                format.json { render json: @object }
                format.html { render @action.template_name }
              end
            end
          end
        end
        register_instance_option :link_icon do
          'icon-info-sign'
        end
      end
    end
  end
end
