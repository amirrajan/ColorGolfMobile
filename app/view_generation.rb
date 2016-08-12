module ViewGeneration
  def render id, klass
    previous_parent = (@current_parent || view)
    v = klass.new
    @current_parent = v
    yield v
    set_view id, v
    @current_parent = previous_parent
    @current_parent.add_child(v)
  end

  def render! id, klass, &block
    render id, klass, &block
    view.update_layout
  end

  def get_view id
    @views[id]
  end

  def set_view id, v
    @views ||= {}
    @views[id] = v
  end

  def width_for id
    width_for_view(get_view(id))
  end

  def width_for_view v
    return v.width if v.width.to_s != "NaN"

    width_for_view(v.parent)
  end
end
