module HandyToolbox

  class Plugin
    PluginNotConfigured = StandardError.new(
      'Plugin not configured (missing #on_attach definition)'
    )

    def on_attach(node)
      raise PluginNotConfigured
    end

  end

end
