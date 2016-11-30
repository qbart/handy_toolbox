module HandyToolbox

  class Menu
    ICON = ' + '.freeze

    attr_reader :id, :tools, :children, :parent

    def initialize(parent, group)
      @id = Ids.next
      @parent = parent
      @group = group
      @children = []

      if !parent.nil?
        @children << MenuBack.new(parent)
      end
    end

    def menu(group, &block)
      menu = Menu.new(self, group)
      children << menu
      yield menu if block_given?
    end

    def menu_loader(group, loader_class)
      loader = loader_class.new
      menu = MenuLoader.new(self, group, loader)
      children << menu
    end

    def tool(cmd, opts = {})
      children << ToolMenuItem.new(parent, Tool.new(cmd, opts))
    end

    def plugin(plugin_class)
      plugin = plugin_class.new
      plugin.on_attach(self)
    end

    def to_s
      @group
    end

    def icon
      ICON
    end
  end

end
