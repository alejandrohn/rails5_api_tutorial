class Api::V1::FeedsController < Api::V1::BaseController
  before_action :load_resource

  def show
    auth_microposts = authorize_with_permissions(@feed)

    render jsonapi: auth_microposts.collection, serializer: Api::V1::MicropostSerializer,
      fields: { microposts: auth_microposts.fields(params[:fields]).concat([:user]) },
      include: []
  end

  private
    def load_resource
      case params[:action].to_sym
      when :show
        @feed = paginate(
          apply_filters(User.find(params[:user_id]).feed, params)
        )
      end
    end
end
