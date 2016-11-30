module HandyToolbox

  class Navigator

    def tool_selected?
      selection.is_a?(ToolMenuItem)
    end

    def tool
      if tool_selected?
        selection.tool
      end
    end

    def selection
      @children[@current_index]
    end

    def select_first
      select_by_index(0)
    end

    def select_last
      select_by_index(@children.size - 1)
    end

    def select_by_index(index)
      if index >= 0 && index < @children.size
        @current_index = index
      end
    end

    def current_parent
      @parent
    end

    def enter_selected
      old = selection
      if selection.id == Ids::BACK
        enter(old.parent)
      else
        enter(selection)
      end
    end

    def enter(parent)
      @parent = parent
      parent.on_load if parent.is_a?(MenuLoader)

      @children = parent.children
      @current_index = 0
      selection
    end

    def up(by = 1)
      @current_index = [0, @current_index - by].max
    end

    def down(by = 1)
      @current_index = [@current_index + by, @children.size - 1].min
    end

  end

end
