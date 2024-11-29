class ReviewsController < ApplicationController
  before_action :set_review, only: [:update, :destroy]
  before_action :set_product, only: [:create]
  before_action :authorize_user!, only: [:destroy]

  def create
    @review = @product.reviews.build(review_params.merge(user: current_user))

    if @review.save
      redirect_to @product, notice: 'Ваш відгук додано.'
    else
      redirect_to @product, alert: 'Не вдалося додати відгук.'
    end
  end

  def update
    if @review.update(review_params)
      redirect_to @review.product, notice: 'Ваш відгук оновлено.'
    else
      redirect_to @review.product, alert: 'Не вдалося оновити відгук.'
    end
  end

  def destroy
    @review.destroy
    redirect_to @review.product, notice: 'Відгук видалено.'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end

  def authorize_user!
    unless current_user == @review.user || current_user.admin?
      redirect_to @review.product, alert: 'У вас немає прав для видалення цього відгуку.'
    end
  end
end
