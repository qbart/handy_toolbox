module HandyToolbox

  class ToolRunner

    def initialize
      @tool = nil
    end

    def queue(tool)
      @tool = tool
    end

    def run
      if !@tool.nil?
        puts @tool.cmd
        Kernel.exec @tool.cmd
      end
    end

  end

end
