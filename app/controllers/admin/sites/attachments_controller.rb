class Admin::Sites::AttachmentsController < ApplicationController
  def destroy
    attachment = ActiveStorage::Attachment.find(params[:blob_id])
    attachment.purge
    redirect_back fallback_location: root_path
  end
end
