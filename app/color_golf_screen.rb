class ColorGolfScreen < UI::Screen
  def on_load
    $self = self
    render_view
  end

  def cause_jni
    true
  end

  def available_percentages
    if cause_jni
      @available_percentages ||= [
        %w(A1 0xA1), %w(A0 0xA0), %w(90 0x90),
        %w(80 0x80), %w(70 0x70), %w(60 0x60),
        %w(50 0x50), %w(40 0x40), %w(30 0x30),
        %w(20 0x20), %w(10 0x10), %w(00 0x00)
      ]
    else
      @available_percentages ||= [
        %w(ff 0xff),
        %w(80 0x80),
        %w(00 0x00)
      ]
    end
  end

  def cell_ids
    return @cell_ids if @cell_ids

    @cell_ids = {}

    available_percentages.each do |tuple|
      @cell_ids["r_#{tuple[0]}".to_sym] = { text: tuple[1] }
      @cell_ids["g_#{tuple[0]}".to_sym] = { text: tuple[1] }
      @cell_ids["b_#{tuple[0]}".to_sym] = { text: tuple[1] }
    end

    @cell_ids
  end

  def render_view
    render_rgb_grid
    view.update_layout
  end

  def render_rgb_grid
    render :none, UI::View do |grid|
      grid.width = 300
      grid.flex_direction = :row
      grid.flex_wrap = :wrap
      grid.justify_content = :center
      grid.align_self = :center

      render :none, UI::Label do |label|
        label.width = 100
        label.text = 'Red'
      end

      render :none, UI::Label do |label|
        label.width = 100
        label.text = 'Green'
      end

      render :none, UI::Label do |label|
        label.width = 100
        label.text = 'Blue'
      end

      cell_ids.each do |id, v|
        render id, UI::Button do |button|
          button.width = 100
          button.title = v[:text]
        end
      end
    end
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
    block.call(v)
    set_view id, v
    @current_parent = previous_parent
    @current_parent.add_child(v) if should_add
  end

  def text? v
    v.is_a?(UI::Button) || v.is_a?(UI::Label)
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
