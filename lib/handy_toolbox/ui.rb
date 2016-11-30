require 'curses'

module HandyToolbox

  class Ui

    def self.pos(x, y)
      Curses.setpos(y, x)
    end

    def self.text(str)
      Curses.addstr(str)
    end

    def self.text_at(x, y, str)
      pos(x, y)
      text(str)
    end

    def self.highlight_on
      attr_on Curses::A_STANDOUT
    end

    def self.highlight_off
      attr_off Curses::A_STANDOUT
    end

    def self.highlight(condition = true)
      highlight_on if condition
      yield
      highlight_off if condition
    end

    def self.dim_on
      attr_on Curses::A_DIM
    end

    def self.dim_off
      attr_off Curses::A_DIM
    end

    def self.dim(condition = true)
      dim_on if condition
      yield
      dim_off if condition
    end

    def self.bold_on
      attr_on Curses::A_BOLD
    end

    def self.bold_off
      attr_off Curses::A_BOLD
    end

    def self.bold(condition = true)
      bold_on if condition
      yield
      bold_off if condition
    end

    def self.hide_cursor
      Curses.curs_set(0)
    end

    def self.attr_on(value)
      Curses.attron(value)
    end

    def self.attr_off(value)
      Curses.attroff(value)
    end

    def self.scroll_by(val)
      Curses.scrl(val)
    end
  end

end
