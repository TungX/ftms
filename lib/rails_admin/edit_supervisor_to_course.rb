module RailsAdmin
  module Config
    module Actions
      class EditSupervisorToCourse < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
         false
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
            @supervisor = User.supervisor
            if request.post?
              course_params = params.require(:course).permit supervisor_ids: [], leader_ids: []
              if course_params["supervisor_ids"].nil? || course_params["leader_ids"].nil?
                Settings.update_supervisor_params.each do |param|
                  object.errors.add(:base, t("error.#{param}")) if
                    course_params["#{param}_ids"].nil?
                end
                render "edit_course"
              else
                if object.update_attributes course_params
                  flash[:success] = t "admin.actions.updated"
                  redirect_to show_path "course", object
                else
                  render "edit_course"
                end
              end
            end
          end
        end
      end
    end
  end
end
