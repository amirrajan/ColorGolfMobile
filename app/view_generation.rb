module ViewGeneration
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

  def attribute_white_list
    { width: :width= }
  end

  def new_render hierarchy
    @views ||= {}
    @view_bread_crumbs ||= [view]
    opts[:id] ||= :none
    id = opts[:id]
    should_add = !@views[id]
    new_view = @views[id] || UI::View.new
    if id == :none
      new_view = UI::View.new
      should_add = true
    end
    new_view.height = 30 if new_view.is_a?(UI::Label)
    new_view.height = 35 if new_view.is_a?(UI::Button)
    new_view.color = :black if text? new_view
    new_view.font = font if text? new_view
    attribute_white_list.each do |attr, method|
      opts[attr] &&
        new_view.respond_to?(method) &&
        new_view.send(method, opts[attr]) && puts(method)
    end
    set_view id, new_view
    @view_bread_crumbs.last.add_child(new_view) if should_add
    @view_bread_crumbs.push new_view
  end

  def ui_view opts

  end

  def ui_label opts
    puts opts
  end

end
