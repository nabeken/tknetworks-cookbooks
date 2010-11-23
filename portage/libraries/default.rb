class Chef
  module PortageResource
    module MaskUnmask
      def _load_current_resource
        @filename = "/etc/portage/package.#{@element}"
        @current_resource, @versions = get_current_resource
      end

      def write_new_resource
        ::File.open(@filename, 'w') do |f|
          @versions.each do |pkg, versions|
            versions.flatten.each do |version|
              version =~ /^([><=]|>=|<=)(.*)/
              f.print "#{$1}#{pkg}-#{$2}\n"
            end
          end
        end
      end

      def get_current_resource
        versions = {}

        case @element
        when :mask
          current_resource = Chef::Resource::PortageMask.new(@new_resource.name)
          current_resource.versions([])
        when :unmask
          current_resource = Chef::Resource::PortageUnmask.new(@new_resource.name)
          current_resource.versions([])
        end

        begin
          ::File.open(@filename).readlines.each do |l|
            l.strip =~ /^([><=]|>=|<=)([\w+][\w+.-]*\/[\w+][\w+-]*?)-((?:([0-9.a-zA-Z]+(?:_(?:alpha|beta|pre|rc|p)[0-9]*)*(?:-r[0-9]*)?)(?:\([^\)]+\))?(?:\[([^\]]+)\])?[ ]*)*)$/
            pkg = $2
            version = "#{$1}#{$3}"

            versions[pkg] = [] if versions[pkg].nil?
            versions[pkg].push version

            if pkg == @new_resource.name
              current_resource.versions.push version
            end

          end
        rescue
          current_resource.versions([])
        end

        ret = [current_resource, versions]
        Chef::Log.info("ret: #{ret.inspect}")
        ret
      end

      def action_create
        # pkgのエントリーが存在していなければcreate
        # 存在していればupdate
        # create or update?
        Chef::Log.info(@versions.inspect)
        if @versions[@new_resource.name].nil?
          # create
          @versions[@new_resource.name] = @new_resource.versions
          write_new_resource
          @new_resource.updated_by_last_action(true)
          Chef::Log.info("#{@new_resource.name} version #{@new_resource.versions.join(",")} in #{@filename} has been created!.")
        else
          action_update
        end
      end

      def action_update
        if @versions[@new_resource.name].nil?
          action_create
        else
          changed = false
          # update
          @new_resource.versions.each do |version|
            next if @versions[@new_resource.name].include?(version)
            changed = true
            @versions[@new_resource.name].push version
            Chef::Log.info("Masking #{@new_resource.name} version #{version} in #{@filename} has been created.")
          end

          if changed
            write_new_resource
            @new_resource.updated_by_last_action(true)
          end
        end
      end

      def action_delete
        unless @versions[@new_resource.name].nil?
          size = @versions[@new_resource.name].size

          @versions[@new_resource.name].delete_if do |v|
            @new_resource.versions.include?(v)
          end

          if size != @versions[@new_resource.name].size
            @versions.delete(@new_resource.name) if @versions[@new_resource.name].empty?
            Chef::Log.info("Masking #{@new_resource.name} version #{@new_resource.versions.join(",")} in #{@filename} has been deleted.")
            write_new_resource
            @new_resource.updated_by_last_action(true)
          end
        end
      end
    end
  end
end
