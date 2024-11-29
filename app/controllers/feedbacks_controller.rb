class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:index, :destroy]  # Додаємо перевірку для destroy

  def new
    @feedback = Feedback.new
    @feedbacks = Feedback.all.order(created_at: :desc) if current_user.admin?
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      flash[:notice] = "Ваше повідомлення успішно надіслано!"
      redirect_to new_feedback_path
    else
      flash.now[:alert] = "Виникла помилка при відправці повідомлення."
      render :new
    end
  end

  def index
    @feedbacks = Feedback.all.order(created_at: :desc)
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    flash[:notice] = "Відгук успішно видалено."
    redirect_to new_feedback_path
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :message)
  end

  def check_admin
    redirect_to root_path, alert: "У вас немає прав для перегляду цієї сторінки." unless current_user.admin?
  end
end
