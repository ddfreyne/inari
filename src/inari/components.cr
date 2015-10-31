class QuitComponent < ::Glove::Component
  def update(entity, delta_time, space, app)
    if LibGLFW.get_key(app.window, LibGLFW::KEY_ESCAPE) == LibGLFW::PRESS
      LibGLFW.set_window_should_close(app.window, 1)
    end
  end
end

# Updates the entity’s translation based on the cursor position.
class CursorFollowingComponent < ::Glove::Component
  def update(entity, delta_time, space, app)
    if transform = entity.transform
      transform.translate_x = app.cursor_position.x
      transform.translate_y = app.cursor_position.y
    end
  end
end

class OnClickComponent < ::Glove::Component
  getter :proc

  def initialize(@proc : (Glove::Entity, Glove::Event, Glove::Space, Glove::App ->))
  end
end

class CardTypeComponent < ::Glove::Component
  getter :string

  def initialize(@string)
  end
end

class VisibleComponent < ::Glove::Component
end
