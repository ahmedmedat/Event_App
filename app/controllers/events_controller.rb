class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /events
  # GET /events.json
  def index
    @j = UserEvent.where(user_id: current_user.id)
      @u = []
    @j.each do |j|
      @u <<j.event_id
    end
    @events = Event.all.where.not(id: @u).where.not(username:current_user.id)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find_by_name(params[:name])
  end

  def view
    @j = UserEvent.where(user_id: current_user.id)
      @u = []
    @j.each do |j|
      @u <<j.event_id
    end
    
    respond_to do |format|
      if @event= Event.where(id: @u).where.not(username:current_user.id)
        format.json { render :index, status: :ok, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end  
  end

  def myevents
    @user =User.find(current_user.id)
      if @event = Event.where(username: @user.username)
        format.json { render :index, status: :ok, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end  
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def going
    @event = Event.find_by_name(params[:name])
    @user= User.find(current_user.id)
    @j = UserEvent.new
    @event.event_users << @j
    @user.event_users << @j

  end

  # POST /events
  # POST /events.json
  def create
    @user= User.find(current_user.id)
    @j = UserEvent.new
    @event = Event.new(params.require(:event).permit(:name,:date,:description,:location))
    @event.username = @user.username

    respond_to do |format|
      if @event.save
        @event.event_users << @j
        @user.event_users << @j
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event = Event.find_by_name(params[:name])
    if @event.username == current_user.username
    respond_to do |format|
      if @event.update_attributes(params.require(:event).permit(:name,:date,:description,:location))
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find_by_name(params[:name])
    if @event.username == current_user.username
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params[:event]
    end
end
