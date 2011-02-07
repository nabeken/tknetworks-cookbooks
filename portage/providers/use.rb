# useは1パッケージ1つと仮定

def load_current_resource
  Chef::Log.info("load current resource for #{@new_resource.name}")
  @element = :use
  @filename = "/etc/portage/package.#{@element}"
  @current_resource = Chef::Resource::PortageUse.new(@new_resource.name)
  @use = {}

  # new_resourceで指定がなければ空
  @new_resource.enable([])  if @new_resource.enable.nil?
  @new_resource.disable([]) if @new_resource.disable.nil?

  # ファイルを開いて全パッケージ名とUSEフラグの対を生成しインスタンス変数 @use へ格納
  begin
    ::File.open(@filename).readlines.each do |l|
      pkg, args = l.strip.split(" ", 2)
      enabled  = getEnabledUse(args)
      disabled = getDisabledUse(args)

      @use[pkg] = {}
      @use[pkg][:enable]  = enabled
      @use[pkg][:disable] = disabled

      # 読み込み中のリソースがファイル中にあれば @current_resource へ @new_resource のフラグを足す
      if @new_resource.name == pkg
        enabled  += @new_resource.enable
        disabled += @new_resource.disable
        @current_resource.enable(enabled)
        @current_resource.disable(disabled)
      end
    end
  rescue
    Chef::Log.info("can not load: #{@new_resource.name}")
    @current_resource.enable(nil)
    @current_resource.disable(nil)
  end
  @current_resource
end

def getEnabledUse(args)
  args.split(/[ \t]+/).reject do |l|
    l =~ /^-/
  end
end

def getDisabledUse(args)
  args.split(/[ \t]+/).select do |l| l =~ /^-/ end.map do |l|
    l[1..-1]
  end
end

def write_new_resource
  ::File.open(@filename, "w") do |f|
    @use.each do |pkg, use|
      flags = use[:enable] + use[:disable].map do |l| "-#{l}" end
      f.print "#{pkg} "
      f.print flags.join(" ")
      f.print "\n"
    end
  end
end

def action_create
  # pkgなければcreate
  # 存在していればupdate
  changed = false
  use = []

  if @use[@new_resource.name].nil?
    @use[@new_resource.name] = {}
  end

  [:enable, :disable].each do |u|
    @use[@new_resource.name][u] = [] if @use[@new_resource.name][u].nil?
    unless @new_resource.__send__(u).nil?
      @new_resource.__send__(u).each do |f|
        unless @use[@new_resource.name][u].include?(f)
          changed = true;
          @use[@new_resource.name][u].push f
          use.push f
        end
      end
    end
  end
  if changed
    write_new_resource
    Chef::Log.info("USE Flags #{use.join(",")} for #{@new_resource.name} has been created.")
    new_resource.updated_by_last_action(true)
  end
end

def action_update
  action_create
end

def action_delete
  changed = false
  deleted = []
  unless @use[@new_resource.name].nil?
    # 1つずつループして指定しているものが存在していれば削除 & フラグを立てる
    # 存在していなければすでに消えているので何もしない
    [:enable, :disable].each do |u|
      @new_resource.__send__(u).each do |f|
        if @use[@new_resource.name][u].include?(f)
          @use[@new_resource.name][u].delete(f)
          deleted.push f
          changed = true
        end
      end
    end
    if changed
      if @use[@new_resource.name][:enable].empty? && @use[@new_resource.name][:disable].empty?
        @use.delete(@new_resource.name)
      end
      write_new_resource
      new_resource.updated_by_last_action(true)
      Chef::Log.info("USE Flags #{deleted.join(",")} for #{@new_resource.name} has been deleted.")
    end
  end
end
