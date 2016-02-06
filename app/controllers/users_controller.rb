class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

  before_action :set_user, :finish_signup
  before_filter :authenticate_user!
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]


 def index
    #authorize! 
    @users = User.all.order('created_at DESC').paginate(:per_page => 10, :page => params[:page])
    unless current_user.admin? || current_user.super_admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  # GET /users/:id.:format
  def show
    @user = User.find(params[:id])
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      #if @user.update(user_params)
      #  @user.skip_reconfirmation!
      if current_user.update(user_params)
        current_user.skip_reconfirmation!
        sign_in(current_user, :bypass => true)
        redirect_to users_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end


  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user = User.find(params[:id])
    if @user.destroy
        flash[:notice] = "User Removed"
        redirect_to root_path
    else
        render 'destroy'
    end
  end

  private
    def set_user
      #@user = User.find(params[:id])
      #@user = User.find(params[:id])
    end

    def user_params
      accessible = [ :first_name, :last_name, :gender, :profile_picture, :link, :email, :age_min, :age_max, :friends, :phone ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
