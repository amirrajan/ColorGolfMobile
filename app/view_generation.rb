module ViewGeneration
  def ui_view opts
    @views ||= {}
    @current_parent ||= view
    opts[:id] ||= :none
    should_add = !@views[id]
    view = @views[id] || klass.new
    if id == :none
      view = klass.new
      should_add = true
    end
    @current_parent = view
    view.height = 30 if view.is_a?(UI::Label)
    view.height = 35 if view.is_a?(UI::Button)
    view.color = :black if text? view
    view.font = font if text? view
    opts.each do |k, v|
      v.send(k, v) if v.responds_to? k
    end
    set_view id, v
    @current_parent.add_child(v) if should_add
  end

  def ui_label opts
    puts opts
  end

  def render id, klass, &block
    @views ||= {}
    previous_parent = (@current_parent || view)
    should_add = !@views[id]
    v = @views[id] || klass.new
    if id == :none
      v = klass.new
      should_add = true
    end
    @current_parent = v
    v.height = 30 if v.is_a?(UI::Label)
    v.height = 35 if v.is_a?(UI::Button)
    v.color = :black if text? v
    v.font = font if text? v
    block.call(v)
    set_view id, v
    @current_parent = previous_parent
    @current_parent.add_child(v) if should_add
  end

  def text? v
    v.is_a?(UI::Button) || v.is_a?(UI::Label)
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
    return v.width unless v.width.nan?

    width_for_view(v.parent)
  end
end
