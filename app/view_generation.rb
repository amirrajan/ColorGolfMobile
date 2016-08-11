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

  def set_view id, view
    @views ||= {}
    @views[id] = view
  end
end
