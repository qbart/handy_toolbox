module HandyToolbox

  class Scroll

    attr_reader :top

    def initialize
      @screen = Curses.stdscr
      @screen.scrollok(true)
      reset
    end

    def reset
      @top = 0
      @max_y = 0
    end

    def update(max_y)
      @max_y = max_y
    end

    def fits_into_pane?(y)
      (y - top) >= 0 && (y - top) < screen.maxy
    end

    def up(by = 1)
      by = @top if @top - by < 0
      if by > 0
        screen.scrl(-by)
        @top -= by
      end
    end

    def down(by = 1)
      by = max_top - @top if @top + by > max_top
      if by > 0
        screen.scrl(by)
        @top += by
      end
    end

    def to(index)
      if index != top
        if index >= 0 && index <= max_top
          by = index - top
          screen.scrl(by)
          @top = index
        elsif index < 0
          to_first
        elsif index > max_top
          to_last
        end
      end
    end

    def to_first
      to(0)
    end

    def to_last
      to(max_top)
    end

  private

    def max_top
      max_y - (screen.maxy - 1)
    end

    attr_reader :screen, :max_y
  end

end
