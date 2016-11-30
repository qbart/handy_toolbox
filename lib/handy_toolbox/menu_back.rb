module HandyToolbox

  class MenuBack

    TEXT = '..'.freeze
    ICON = '<- '.freeze

    attr_reader :id, :parent

    def initialize(parent)
      @id = Ids::BACK
      @parent = parent
    end

    def to_s
      TEXT
    end

    def icon
      ICON
    end

  end

end
