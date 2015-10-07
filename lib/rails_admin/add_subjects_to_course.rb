module RailsAdmin
  module Config
    module Actions
      class AddSubjectsToCourse < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized? && bindings[:object].class == Course
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-plus"
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :controller do
          proc do
            @course = object
            @subjects = Subject.all
            if request.post?
              course_params = params.require(:course).permit subject_ids: []
              if object.update_attributes course_params
                flash[:success] = t "admin.actions.updated"
                redirect_to show_path "course", object
              else
                render "add_trainee_to_course"
              end
            end
          end
        end
      end
    end
  end
end
