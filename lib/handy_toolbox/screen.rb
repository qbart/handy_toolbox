require 'curses'

module HandyToolbox

  class Screen
    SPACE = ' '.freeze

    attr_reader :scroll

    def initialize(default_colors: false)
      @default_colors = default_colors
    end

    def init
      Curses.init_screen
      Curses.start_color
      Curses.use_default_colors if @default_colors
      Ui.hide_cursor
      Curses.cbreak
      Curses.crmode
      Curses.noecho
      Curses.nonl
      Curses.stdscr.keypad(true)
      @scroll = Scroll.new
    end

    def clear
      scroll.reset
      Curses.clear
    end

    def draw
      @max_y = 0
      yield
      @scroll.update(@max_y)
      Curses.refresh
    end

    def header(title)
      title = " #{title}"[0, Curses.cols - 1]
      title = title.ljust(Curses.cols, SPACE)

      Ui.reverse do
        if scroll.fits_into_pane?(-scroll.top)
          Ui.text_at(0, -scroll.top, title)
        end
      end
    end

    def text_at(x, y, str)
      if scroll.fits_into_pane?(y)
        str = str[0, Curses.cols - x - 1]
        Ui.text_at(x, y - scroll.top, str)
      end
      @max_y = y if @max_y < y
    end

    def close
      Curses.close_screen
    end

  private

    attr_reader :screen

  end

end
