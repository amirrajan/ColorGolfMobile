module ViewGeneration
  def button id, text, width = :fill
    b = Android::Widget::Button.new self
    b.setText text
    b.setTextSize 2, 14
    b.setOnClickListener(self)
    b.setBackground(button_background)

    ld = layout_definition(
      width: width,
      height: row_height,
      margin_top: 10,
      weight: 0.3,
      margin_bottom: 10,
      margin_right: 10,
      margin_left: 10
    )

    yield ld, b if block_given?

    b.setLayoutParams(ld)

    b.id = id

    b
  end

  def link id, text
    b = Android::Widget::Button.new self
    b.setText text
    b.setTextSize 2, 14
    b.setTextColor Android::Graphics::Color.argb(255, 0, 96.0, 255.0)
    b.setOnClickListener(self)
    b.setBackground(link_background)

    ld = layout_definition(
      width: :auto,
      height: :auto,
      margin_top: 10,
      weight: 0.3,
      margin_bottom: 10,
      margin_right: 10,
      margin_left: 10
    )

    yield ld, b if block_given?

    b.setLayoutParams(ld)

    b.id = id if id.is_a? Fixnum

    b
  end

  def link_background
    getResources.getDrawable(resources.getIdentifier(:link_background, :drawable, 'com.yourcompany.adarkroom'))
  end

  def button_background
    getResources.getDrawable(resources.getIdentifier(:button_background, :drawable, 'com.yourcompany.adarkroom'))
  end

  def hidden_button id, text, width = :fill
    raise "hidden_button cannot take in an implicit block" if block_given?

    button(id, text, width) { |_, b| hide b }
  end

  def text_view id, text
    tv = Android::Widget::TextView.new(self)
    ld = layout_definition(width: :fill)
    tv.setText(text)
    tv.setGravity(gravity_center)
    tv.setTextSize(2, 14)
    tv.setLayoutParams(ld)
    yield ld, tv if block_given?
    tv.id = id if id.is_a? Fixnum
    tv
  end

  def spacer()
    fl = Android::Widget::FrameLayout.new(self)
    ld = layout_definition(width: :fill, height: :fill)
    yield ld if block_given?
    fl.setLayoutParams(ld)
    fl
  end

  def progress_bar vertical_layout_id, text_view_id, progress_bar_id, text
    pg = Android::Widget::ProgressBar.new(
      self,
      nil, Android::R::Attr::ProgressBarStyleHorizontal)
    pg.setOnClickListener(self)
    pg.setClickable(true)
    pg.setIndeterminate(false)
    pg.setLayoutParams(layout_definition(width: :fill, height: :auto, margin_left: 5, margin_right: 5, margin_bottom: 5))
    pg.id = progress_bar_id
    tv = text_view(text_view_id, text) do |layout|
      layout.setMargins(0, 5, 0, 0)
    end
    tv.setTextSize(2, 16)
    tv.setOnClickListener(self)
    vl = vertical_layout(vertical_layout_id, tv, pg)
    vl
  end

  def vertical_layout id, *views
    vl = Android::Widget::LinearLayout.new(self)
    vl.setOrientation(Android::Widget::LinearLayout::VERTICAL)
    vl.setBaselineAligned(false)
    vl.setDrawingCacheQuality(1)
    ld = layout_definition(width: :fill)
    yield ld, vl if block_given?
    vl.setLayoutParams(ld)
    vl.id = id if id.is_a? Fixnum
    views.each { |v| vl.addView(v) }
    vl
  end

  def horizontal_layout id, *views
    hl = Android::Widget::LinearLayout.new(self)
    hl.setOrientation(Android::Widget::LinearLayout::HORIZONTAL)
    hl.setBaselineAligned(false)
    hl.setDrawingCacheQuality(1)
    ld = layout_definition(width: :fill)
    yield ld, hl if block_given?
    hl.setLayoutParams(ld)
    views.each { |v| hl.addView(v) }
    hl.id = id if id.is_a? Fixnum
    hl
  end

  def relative_layout id, *views
    rl = Android::Widget::RelativeLayout.new(self)
    rl.setDrawingCacheQuality(1)
    ld = layout_definition(width: :fill, height: :fill)
    yield ld, rl if block_given?
    rl.setLayoutParams(ld)
    views.each { |v| rl.addView(v) }
    rl.id = id if id.is_a? Fixnum
    rl
  end

  def scroll_view id, *views
    sv = Android::Widget::ScrollView.new(self)
    sv.id = id if id.is_a? Fixnum
    sv.setLayoutParams(layout_definition(width: :fill))
    sv.setSmoothScrollingEnabled(true)
    sv.setFillViewport(true)
    ld = layout_definition(width: :fill)
    yield ld if block_given?
    sv.setLayoutParams(ld)
    views.each { |v| sv.addView(v) }
    sv
  end

  def layout_definition opts
    attrs = {
      fill: fill,
      auto: auto
    }

    width = attrs[opts[:width] || :auto] || opts[:width]
    height = attrs[opts[:height] || :auto] || opts[:height]
    left = opts[:margin_left] || 0
    top = opts[:margin_top] || 0
    right = opts[:margin_right] || 0
    bottom = opts[:margin_bottom] || 0

    layout = Android::Widget::LinearLayout::LayoutParams.new(width, height, opts[:weight] || 0)
    layout.setMargins(left, top, right, bottom)
    layout
  end

  def resolve_type type
    @lookup ||= {
      button: Android::Widget::Button,
      progress_bar: Android::Widget::ProgressBar,
      text_view: Android::Widget::TextView,
      scroll_view: Android::Widget::ScrollView,
      linear_layout: Android::Widget::LinearLayout
    }

    @lookup[type] || type
  end

  def pb_disabled_color
    @pb_disabled_color ||= Android::Graphics::LightingColorFilter.new("FF000000".hex, "FF666666".hex)
    @pb_disabled_color
  end

  def fill
    Android::Widget::LinearLayout::LayoutParams::MATCH_PARENT
  end

  def auto
    Android::Widget::LinearLayout::LayoutParams::WRAP_CONTENT
  end

  def gravity_left
    Android::View::Gravity::LEFT
  end

  def gravity_center
    Android::View::Gravity::CENTER
  end

  def gravity_center_vertical
    Android::View::Gravity::CENTER_VERTICAL
  end

  def gravity_bottom
    Android::View::Gravity::BOTTOM
  end

  def hide view
    view.setVisibility(0x0000000004)
  end

  def gone view
    view.setVisibility(0x0000000008)
  end

  def fade_in view, animate
    return if view.getVisibility() == 0x0000000000

    if animate
      view.setAlpha(0)
      view.setVisibility(0x0000000000)

      a = Android::Animation::ObjectAnimator.new
      a.target = view
      a.propertyName = "alpha"
      a.setObjectValues([0, 1])
      a.setEvaluator(Android::Animation::FloatEvaluator.new)
      a.setDuration(1000)
      a.start
    else
      view.setAlpha(100)
      view.setVisibility(0x0000000000)
    end
  end

  def device_height
    return @dm.heightPixels if @dm

    @dm = Android::Util::DisplayMetrics.new
    getWindowManager().getDefaultDisplay().getMetrics(@dm)
    @dm.heightPixels
  end

  def device_width
    return @dm.widthPixels if @dm

    @dm ||= Android::Util::DisplayMetrics.new
    getWindowManager().getDefaultDisplay().getMetrics(@dm)
    @dm.widthPixels
  end

  def row_height
    @row_height ||= (device_height * 0.4) / device_height_in_inches
    # @row_height ||= device_height * 0.11111111
  end

  def row_width
    @row_height ||= (device_width * 0.4) / device_width_in_inches
  end

  def device_width_in_inches
    @dm ||= Android::Util::DisplayMetrics.new
    getWindowManager().getDefaultDisplay().getMetrics(@dm)
    width = @dm.widthPixels
    dens = @dm.densityDpi
    width.fdiv(dens)
  end

  def device_height_in_inches
    @dm ||= Android::Util::DisplayMetrics.new
    getWindowManager().getDefaultDisplay().getMetrics(@dm)
    height = @dm.heightPixels
    dens = @dm.densityDpi
    height.fdiv(dens)
  end
end

# usage
=begin
horizontal_layout(
  :none,
  button(
    BUTTON_OUTSIDE,
    "a silent forest"),
  button(
    BUTTON_EMBARK,
    "a dusty path")
)
=end
