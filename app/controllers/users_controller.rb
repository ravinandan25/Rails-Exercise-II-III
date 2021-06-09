class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_login, except: %i[new create]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    if current_user.id != @user.id
      redirect_to users_path
      flash[:notice] = "You can only view your details i.e. #{current_user.email}."
    end
  end

  # GET /users/new
  def new
    if current_user.nil?
      @user = User.new
    else
      redirect_to users_path, notice: 'You already LogedIn'
    end
  end

  # GET /users/1/edit
  def edit
    if current_user.id != @user.id
      redirect_to users_path
      flash[:notice] = "You can only edit your details i.e  #{current_user.email}"
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'User was successfully created. Please Log in to access profile!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if current_user.id != @user.id
      redirect_to users_path
      flash[:notice] = "You can only delete your Profile i.e. #{current_user.email}."
    else
      @user.destroy
      respond_to do |format|
        session[:user_id] = nil
        format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def require_login
    redirect_to login_url, alert: 'You must be logged in to access this section' unless current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
