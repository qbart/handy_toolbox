module HandyToolbox

  class MenuLoader < Menu
    NOT_LOADED_YET_ICON = ' % '

    def initialize(parent, group, loader)
      super(parent, group)
      @loader = loader
      @loaded = false
    end

    def on_load
      if !@loaded
        @loader.on_load(self)
        @loaded = true
      end
    end

    def icon
      @loaded ? super : NOT_LOADED_YET_ICON
    end

  end

end
