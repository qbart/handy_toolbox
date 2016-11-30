require 'curses'

module HandyToolbox

  class Screen

    attr_reader :scroll

    def init
      Curses.init_screen
      Curses.start_color
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

    def text_at(x, y, str)
      if scroll.fits_into_pane?(y)
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
