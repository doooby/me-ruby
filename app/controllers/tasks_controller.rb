class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def summary
    @tasks = Task.all
      .limit(10)

    respond_to do |format|
      format.json do
        render json: {
          payload: {
            page: 1,
            per_page: 10,
            list: @tasks.map{ Task::Recordable.to_data _1 }
          }
        }
      end
      format.html
    end
  end
end
