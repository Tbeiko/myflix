class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.create(invitation_params.merge!(inviter_id: current_user.id))

    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "Your invitation is on it's way!"
      redirect_to new_invitation_path
    else
      flash[:danger] = "Something went wrong, please try again."
      render :new
    end
  end

  private 

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :token)
  end
end