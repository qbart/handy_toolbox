module HandyToolbox

  class ToolMenuItem

    ICON = '   '.freeze

    attr_reader :id, :parent, :tool

    def initialize(parent, tool)
      @id = Ids.next
      @parent = parent
      @tool = tool
    end

    def to_s
      if @tool.desc.nil?
        @tool.name
      else
        [@tool.name, @tool.desc]
      end
    end

    def icon
      ICON
    end

  end

end
