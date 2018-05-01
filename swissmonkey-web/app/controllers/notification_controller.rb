# Endpoints for notifications
class NotificationController < AuthenticatedController
  def mark_read; end

  def count
    # TODO: do something real here
    @count = 0
  end

  def change_count; end
end
