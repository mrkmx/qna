class FilesController < ApplicationController
  
  authorize_resource class: ActiveStorage::Attachment

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if can? :destroy, @file.record
  end
end
