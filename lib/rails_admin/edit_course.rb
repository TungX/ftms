module RailsAdmin
  module Config
    module Actions
      class EditCourse < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-pencil"
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :controller do
          proc do
            if request.post?
              course_params = params.require(:course).permit :name, :description
              if object.update_attributes course_params
                flash[:success] = t "admin.actions.updated"
                redirect_to show_path "course", object
              else
                render "edit_course"
                flash[:danger] = t "admin.actions.not_updated"
              end
            elsif request.get?
              @supervisor = User.supervisor
              @subjects = Subject.subject_not_start_course object
              @trainees = (User.free_trainees << object.users).flatten!.sort
              case params[:object]
              when "subject"
                @subjects = Subject.send "subject_#{params[:option]}", object.id
                respond_to do |format|
                  format.html
                  format.js{render "rails_admin/main/order_subject"}
                end
              when "trainee"
                case params[:option]
                when "in"
                  @trainees = object.users
                when "out"
                  @trainees = User.free_trainees
                else
                  @trainees = (User.free_trainees << object.users).flatten!.sort
                end
                respond_to do |format|
                  format.html
                  format.js{render "rails_admin/main/order_trainee"}
                end
              else
              end
            end
          end
        end
      end
    end
  end
end
