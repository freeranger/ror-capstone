class ThingsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  before_action :set_thing, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  wrap_parameters :thing, include: ["name", "description", "notes"]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def index
    authorize Thing
    things = policy_scope(Thing.all)
    @things = ThingPolicy.merge(things)
  end

  def show
    authorize @thing
    things = ThingPolicy::Scope.new(current_user,
                                    Thing.where(:id=>@thing.id))
                                    .user_roles_and_tags(false)
                                    
    @thing = ThingPolicy.merge(things).first
  end

  def create
    authorize Thing
    @thing = Thing.new(thing_params)
    if (params[:tags])
      @thing.thing_tags.clear
      params[:tags].split(",").each do |tag|
        @thing.thing_tags << ThingTag.new(:tag => tag, :thing => @thing)
      end
    end
    User.transaction do
      if @thing.save
        role=current_user.add_role(Role::ORGANIZER,@thing)
        @thing.user_roles << role.role_name
        role.save!
        render :show, status: :created, location: @thing
      else
        render json: {errors:@thing.errors.messages}, status: :unprocessable_entity
      end
    end
  end

  def update
    authorize @thing
    authorize @thing, :manage_tags? if params[:tags]
    User.transaction do
      if (params[:tags])
        # get all the incoming tags.
        tags_arr = params[:tags].split(",").map! {|t| t.strip}
        # delete ones that no longer exist
        @thing.thing_tags.each do |existing_tag|
          @thing.thing_tags.delete(existing_tag) unless tags_arr.include?(existing_tag.tag)
        end
        # now add new ones
        tags_arr.each do |tag|
          puts ":#{tag}:"
          @thing.thing_tags << ThingTag.new(:tag => tag, :thing => @thing) unless @thing.thing_tags.exists?(:tag => tag)
        end
      end
      if @thing.update(thing_params)
        head :no_content
      else
        render json: {errors:@thing.errors.messages}, status: :unprocessable_entity
      end
      end
  end

  def destroy
    authorize @thing
    @thing.destroy

    head :no_content
  end

  private

    def set_thing
      @thing = Thing.includes(:thing_tags).find(params[:id])
    end

    def thing_params
      params.require(:thing).tap {|p|
          p.require(:name) #throws ActionController::ParameterMissing
        }.permit(:name, :description, :notes)
    end
end
