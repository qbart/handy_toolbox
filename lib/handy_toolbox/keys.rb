require 'curses'

module HandyToolbox

  class Keys
    ESC = 'q'
    UP = Curses::KEY_UP
    DOWN = Curses::KEY_DOWN
    FIRST = Curses::KEY_HOME
    LAST = Curses::KEY_END
    PAGE_UP = Curses::KEY_PPAGE
    PAGE_DOWN = Curses::KEY_NPAGE
    ENTER_ARR = [Curses::KEY_ENTER, 13, 10]

    def self.get
      Curses.getch
    end
  end

end
