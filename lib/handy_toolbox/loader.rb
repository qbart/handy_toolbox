module HandyToolbox

  class Loader
    LoaderNotConfigured = StandardError.new(
      'Loader not configured (missing #on_load definition)'
    )

    def on_load(node)
      raise LoaderNotConfigured
    end

  end

end
