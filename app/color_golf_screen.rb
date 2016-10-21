class ColorGolfScreen < UI::Screen
  include ViewGeneration

  def on_show
    navigation.hide_bar
  end

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
        %w(A0 0xA0),
        %w(90 0x90),
        %w(80 0x80),
        %w(70 0x70),
        %w(60 0x60),
        %w(50 0x50),
        %w(40 0x40),
        %w(30 0x30),
        %w(20 0x20),
        %w(10 0x10),
        %w(00 0x00)
      ]
    else
      @available_percentages ||= [
        %w(ff 0xff),
        # %w(bf 0xbf),
        %w(80 0x80),
        # %w(3f 0x3f),
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
    header_width = 100

    cell_width = (header_width - 30).fdiv(3)

    render :none, UI::View do |grid|
      grid.width = header_width
      grid.margin = 5
      grid.flex_direction = :row
      grid.flex_wrap = :wrap
      grid.justify_content = :center
      grid.align_self = :center

      render :none, UI::Label do |label|
        label.width = cell_width
        label.text = 'Red'
        label.align_self = :center
        label.text_alignment = :center
      end

      render :none, UI::Label do |label|
        label.width = cell_width
        label.text = 'Green'
        label.align_self = :center
        label.text_alignment = :center
      end

      render :none, UI::Label do |label|
        label.width = cell_width
        label.text = 'Blue'
        label.align_self = :center
        label.text_alignment = :center
      end

      cell_ids.each do |id, v|
        render id, UI::Button do |button|
          button.width = cell_width
          button.title = v[:text]
        end
      end
    end
  end
end
