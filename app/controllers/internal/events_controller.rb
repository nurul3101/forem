module Internal
  class EventsController < ApplicationController
    layout "internal"
    include ApplicationHelper

    def index
      @event = Event.new(
        location_name: "#{URL.domain}/live",
        location_url: app_url,
        description_markdown: "*Description* *Pre-requisites:* *Bio*",
      )
      @events = Event.order(starts_at: :desc)
    end

    def create
      @event = Event.new(event_params)
      @events = Event.order(starts_at: :desc)
      if @event.save
        flash[:success] = "Successfully created event: #{@event.title}"
        redirect_to(action: :index)
      else
        flash[:danger] = @event.errors.full_messages
        render "index.html.erb"
      end
    end

    def update
      @event = Event.find(params[:id])
      @events = Event.order(starts_at: :desc)
      if @event.update(event_params)
        flash[:success] = "#{@event.title} was successfully updated"
        redirect_to "/internal/events"
      else
        flash[:danger] = @event.errors.full_messages
        render "index.html.erb"
      end
    end

    private

    def event_params
      allowed_params = %i[
        title category event_date starts_at ends_at
        location_name cover_image location_url description_markdown published
        host_name profile_image live_now
      ]
      params.require(:event).permit(allowed_params)
    end
  end
end
