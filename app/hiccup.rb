module Hiccup
  def control_map
    {
      view: UI::View,
      label: UI::Label,
      button: UI:: Button
    }
  end

  def special_keys
    [:id, :tap, :meta, :class]
  end

  def set_attribute view, k, v
    return if special_keys.include? k

    if v == :center
      view.send("#{k}=", :center)
    elsif v == :row
      view.send("#{k}=", :row)
    else
      view.send("#{k}=", v)
    end
  end

  def new_view view_symbol, attributes, styles
    unless control_map.keys.include? view_symbol
      puts "#{view_symbol} not supported as attributes"
      return nil
    end

    attributes = {} if attributes.is_a? Array

    attributes =
      (styles[view_symbol] || {})
        .merge(styles[attributes[:class]] || {})
        .merge(attributes)

    new_view = control_map[view_symbol].new

    attributes.each do |k, v|
      set_attribute new_view, k, v
    end

    attributes[:tap] && new_view.on(:tap) { send(attributes[:tap], new_view, attributes) }

    hash = { view: new_view, attributes: attributes, meta: attributes[:meta] }

    if attributes[:id]
      @views[attributes[:id]] = hash
    end

    if attributes[:class]
      @classes[attributes[:class]] ||= []
      @classes[attributes[:class]] << hash
    end

    new_view
  end

  def control_definition? o
    return false unless o
    return false unless [2, 3].include? o.length
    return false unless control_map.keys.include? o.first
    true
  end

  def find_first_unbox target, parent
    if target.first.is_a? Array
      find_first_unbox(target.first, target)
    else
      parent
    end
  end

  def add_to_parent parent, definition, styles
    if definition[0].is_a? Symbol
      v = new_view definition[0], definition[1], styles
      content = definition[2]

      if definition[1].is_a? Array
        content = definition[1]
      end

      if content
        if control_definition?(content)
          add_to_parent v, content, styles
        elsif content.is_a?(Array)
          find_first_unbox(content, nil).each { |unboxed| add_to_parent v, unboxed, styles }
        else
          puts "#{content} is not supported as content"
        end
      end

      parent.add_child v if v
    elsif definition[0].is_a? Array
      find_first_unbox(definition, nil).each { |unboxed| add_to_parent parent, unboxed, styles }
    else
      puts "first value of #{definition} wasn't a symbol or array"
    end
  end

  def render definition, styles
    @views ||= {}
    @classes ||= {}
    add_to_parent view, definition, styles
  end
end
