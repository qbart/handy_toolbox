module HandyToolbox

  class Cmd

    attr_reader :output

    def initialize(cmd)
      @cmd = cmd
    end

    def self.exec(cmd)
      Cmd.new(cmd).exec
    end

    def exec
      @output = `#{@cmd} 2> /dev/null`.rstrip
      if ok?
        output
      end
    end

  private

    def ok?
      !output.empty?
    end

  end

end
