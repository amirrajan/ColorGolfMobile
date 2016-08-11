module ViewGeneration
  def render_root klass, &block
    @current_parent = view
    render :root, klass, &block
  end

  def render id, klass
    previous_parent = @current_parent
    v = klass.new
    @current_parent = v
    yield v
    @current_parent = previous_parent
    @current_parent.add_child(v)
  end
end
