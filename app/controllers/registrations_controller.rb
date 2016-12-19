class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters

  def create
    build_resource sign_up_params
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up resource_name, resource
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      resource.errors.full_messages.each {|x| flash[x] = x}
      redirect_to root_url
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:full_name, :organization_id]
  end
end
