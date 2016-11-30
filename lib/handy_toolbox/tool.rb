module HandyToolbox

  class Tool

    attr_reader :cmd

    def initialize(cmd, opts = {})
      @cmd = cmd
      @opts = opts
    end

    def name
      opts[:name] || @cmd
    end

    def desc
      opts[:desc]
    end

  private

    attr_reader :opts

  end

end
