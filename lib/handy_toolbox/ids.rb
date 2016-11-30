module HandyToolbox

  class Ids
    # 0..99 are reserved
    BACK = 0
    FIRST = 100
    @@id = FIRST - 1

    def self.next
      @@id += 1
      @@id
    end
  end

end
