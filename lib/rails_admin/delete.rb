module RailsAdmin
  module Config
    module Actions
      class Delete < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :route_fragment do
          "delete"
        end

        register_instance_option :http_methods do
          [:get, :delete]
        end

        register_instance_option :authorization_key do
          :destroy
        end

        register_instance_option :controller do
          proc do
            if request.get? 
              respond_to do |format|
                format.html {render @action.template_name}
                format.js {render @action.template_name, layout: false}
              end
            elsif request.delete?
              redirect_path = nil
              @auditing_adapter && @auditing_adapter.delete_object(@object,
                @abstract_model, _current_user)
              if @object.destroy
                flash[:success] = t "admin.flash.successful",
                  name: @model_config.label, action: t("admin.actions.delete.done")
                case object.class.to_s
                  when "UserCourse"
                    redirect_to request.referer
                  when "CourseSubject"
                    redirect_to request.referer
                  else
                    redirect_to back_or_index
                end
              else
                flash[:error] = t "admin.flash.error",
                  name: @model_config.label, action: t("admin.actions.delete.done")
                redirect_to back_or_index
              end
            end
          end
        end

        register_instance_option :link_icon do
          "icon-remove"
        end
      end
    end
  end
end
