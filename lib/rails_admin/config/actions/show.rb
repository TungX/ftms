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
            # @user = object
            # if @user_course = @user.user_courses.actived.last
            #   @inprogress_course = @user_course.course
            #   @finished_courses = @user.courses.finish
            # end
            respond_to do |format|
              format.json { render json: @object }
              format.html { render @action.template_name }
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
