# frozen_string_literal: true

class SpacesController < ApplicationController
  before_action :set_space, only: %i[show edit update destroy]
  before_action :check_saas_mode, only: %i[new index]
  before_action :set_space_and_user_roles, only: %i[create]

  # GET /spaces or /spaces.json
  def index
    @spaces = current_user.spaces
  end

  # GET /spaces/1 or /spaces/1.json
  def show; end

  # GET /spaces/new
  def new
    @space = Space.new
  end

  # GET /spaces/1/edit
  def edit; end

  # POST /spaces or /spaces.json
  def create
    respond_to do |format|
      if @space.save
        format.html { redirect_to space_url(@space), notice: 'Space was successfully created.' }
        format.json { render :show, status: :created, location: @space }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1 or /spaces/1.json
  def update
    authorize @space

    respond_to do |format|
      if @space.update(space_params)
        format.html { redirect_to edit_space_path(@space), notice: 'Space was successfully updated.' }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spaces/1 or /spaces/1.json
  def destroy
    @space.destroy

    respond_to do |format|
      format.html { redirect_to spaces_url, notice: 'Space was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_space
    @space = Space.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def space_params
    params.require(:space).permit(:name, :phone, :email, :status, :address, :user_ids)
  end

  def check_saas_mode
    return unless !Rails.application.config.saas_mode && Space.count.positive?

    redirect_back fallback_location: root_path
  end

  def set_space_and_user_roles
    @space = Space.new(space_params)
    @space.user_roles.each { |user_role| user_role.role = Role.first }
  end
end
