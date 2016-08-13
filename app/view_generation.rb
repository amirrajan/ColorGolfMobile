module ViewGeneration
  def render id, klass
    @views ||= { }
    previous_parent = (@current_parent || view)
    should_add = !@views[id]
    v = @views[id] || klass.new
    @current_parent = v
    v.height = 30 if v.is_a? UI::Button
    yield v
    set_view id, v
    @current_parent = previous_parent
    @current_parent.add_child(v) if should_add
  end

  def render! id, klass, &block
    render id, klass, &block
    view.update_layout
  end

  def get_view id
    @views[id]
  end

  def set_view id, v
    @views[id] = v
  end

  def width_for id
    width_for_view(get_view(id))
  end

  def width_for_view v
    return v.width if !v.width.nan?

    width_for_view(v.parent)
  end
end
