class OrienteeringPlugin
  include Purugin::Plugin, Purugin::Colors
  description "Orienteering", 0.1

  def on_enable
    player_command('wp', 'waypoints', '/wp set') do |player, *args|
      command, name = args

      case command
      when 'set'
        loc = player.location
        config.set!("#{player.name}.waypoints.#{name}", "#{player.world.name}:#{loc.x},#{loc.y},#{loc.z}")
        player.msg colorize("{green}Set waypoint #{name}")
      when 'gset'
        loc = player.location
        config.set!("__global.waypoints.#{name}", "#{player.world.name}:#{loc.x},#{loc.y},#{loc.z}")
        player.msg colorize("{green}Set global waypiont #{name}")
      when 'list'
        locs = config.get("__global.waypoints")
        if locs && !locs.empty?
          player.msg colorize("{blue}Global waypoints:")
          locs.each { |name, loc| player.msg colorize("   {blue}* #{name}") }
        end

        locs = config.get("#{player.name}.waypoints")
        if locs && !locs.empty?
          player.msg colorize("{blue}Your waypoints:")
          locs.each { |name, loc| player.msg colorize("   {blue}* #{name}") }
        end
      when 'delete'
        config.remove!("#{player.name}.waypoints.#{name}")
      when 'go'
        loc = config.get("#{player.name}.waypoints.#{name}") || config.get("__global.waypoints.#{name}")
        if loc
          world, points = loc.split(':')
          x, y, z = points.split(',').map(&:to_f)
          location = org.bukkit.Location.new(org.bukkit.Bukkit.getWorld(world), x, y, z)
          player.msg colorize("{blue}Teleporting to #{name}")
          player.teleport(location)
        else
          player.msg colorize("{red}No such waypoint '#{name}'")
        end
      end
    end
  end
end
