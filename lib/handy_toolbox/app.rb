module HandyToolbox

  class App
    attr_reader :title

    def initialize(title: "Tools")
      @title = title
      @loop = true
      @builder = Menu.new(nil, nil)
      @screen = Screen.new
      @navigator = Navigator.new
      @tool_runner = ToolRunner.new
      @positions = {}
    end

    def run
      screen.init
      navigator.enter(builder)

      begin

        while @loop
          screen.draw do
            draw_title
            draw_tools
          end
          handle_input
        end

      ensure
        screen.close
        tool_runner.run
      end
    end

    def plugin(plugin_class)
      builder.plugin(plugin_class)
    end

    def menu(group, &block)
      builder.menu(group, &block)
    end

    def menu_loader(group, loader_class)
      builder.menu_loader(group, loader_class)
    end

    def tool(cmd, opts = {})
      builder.tool(cmd, opts)
    end

  private

    attr_reader :screen, :builder, :navigator, :tool_runner

    def handle_input
      key = Keys.get

      case key
      when Keys::ESC
        close_app
      when Keys::UP
        navigator.up
        adjust_scroll_position
      when Keys::DOWN
        navigator.down
        adjust_scroll_position
      when Keys::PAGE_UP
        navigator.up(10)
        adjust_scroll_position
      when Keys::PAGE_DOWN
        navigator.down(10)
        adjust_scroll_position
      when Keys::FIRST
        screen.scroll.to_first
        navigator.select_first
      when Keys::LAST
        screen.scroll.to_last
        navigator.select_last
      when *Keys::ENTER_ARR
        if navigator.tool_selected?
          tool_runner.queue(navigator.tool)
          close_app
        else
          screen.clear
          navigator.enter_selected
        end
      end
    end

    def adjust_scroll_position
      if !screen.scroll.fits_into_pane?(@positions[navigator.selection.id])
        screen.scroll.to(@positions[navigator.selection.id] - 5)
      end
    end

    def draw_title
      horizontal_line = "-" * (title.size + 4)
      padded_title = "| #{title} |"

      screen.text_at(0, 0, horizontal_line)
      screen.text_at(0, 1, padded_title)
      screen.text_at(0, 2, horizontal_line)
    end

    def draw_tools
      y = 4
      longest = find_longest_child_name
      @positions = {}
      current.children.each_with_index do |child|
        str = child.to_s
        is_dir = !child.is_a?(ToolMenuItem)
        is_selected = (navigator.selection.id == child.id)
        is_multiline = str.is_a?(Array)
        offset = (is_multiline ? 3 : 1)

        Ui.bold(is_dir) do
          Ui.highlight(is_selected) do
            if is_multiline
              Ui.dim do
                text = format_desc(str[1])
                screen.text_at(2, y + 1, text)
              end
              text = format_child_name(child.icon, str[0], longest)
              screen.text_at(2, y + 2, text)
              @positions[child.id] = y + 2
            else
              text = format_child_name(child.icon, str, longest)
              screen.text_at(2, y, text)
              @positions[child.id] = y
            end
          end
        end

        y += offset
      end
    end

    def current
      navigator.current_parent
    end

    def format_desc(str)
      "     # #{str}"
    end

    def format_child_name(icon, name, max_len)
      "  #{icon}#{name.ljust(max_len, ' ')}  "
    end

    def find_longest_child_name
      longest_element = current.children.max do |a, b|
        first = a.to_s
        second = b.to_s
        first = first[0] if first.is_a?(Array)
        second = second[0] if second.is_a?(Array)
        first.size <=> second.size
      end
      str = longest_element.to_s
      str.is_a?(Array) ? str[0].size : str.size
    end

    def close_app
      @loop = false
    end

  end

end
