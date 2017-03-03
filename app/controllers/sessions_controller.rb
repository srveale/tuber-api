class SessionsController < ApplicationController
  def create
    data = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    Rails.logger.error params.to_yaml
    user = User.where(email: params[:email]).first
    head 406 and return unless user
    if user.authenticate(params[:password])
      this_user = user.tutor || user.student
      this_user.email = user.email
      this_user.regenerate_token
      byebug
      render json: this_user, status: :created, meta: default_meta and return
    end
    head 403
  end

  def destroy
    token = params[:id]
    token[0] = ''  # Get rid of the prepended colon
    user = User.where(token: token).first
    head 404 and return unless user
    user.regenerate_token
    head 204
  end
end