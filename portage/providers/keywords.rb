# keywordは1パッケージ1つと仮定
def load_current_resource
  @element = :keywords
  @keywords = []
  @current_resource = Chef::Resource::PortageKeywords.new(@new_resource.name)

  begin
    ::File.open("/etc/portage/package.#{@element}").readlines.each do |l|
      pkg, args = l.strip.split(" ", 2)
      if pkg == @new_resource.name
        @current_resource.keyword(args)
        break
      end
    end
    @keywords = ::File.open("/etc/portage/package.#{@element}").readlines.map do |l| l.strip end
  rescue
    @current_resource.keyword(nil)
  end

  @current_resource
end

def write_new_resource
  ::File.open("/etc/portage/package.#{@element}", "w") do |f|
    f.print @keywords.join("\n")
  end
end

def find_index
  # 既存keywordの存在している添字番号
  @keywords.find_index do |l|
    Regexp.new("^#{@new_resource.name}") =~ l
  end
end

def action_create
  # 既存keywordの存在している添字番号
  keyword_index = find_index

  if keyword_index.nil?
    # pkgが存在しなければcreateする
    @keywords.push "#{@new_resource.name} #{@new_resource.keyword}"
    write_new_resource
    Chef::Log.info("Keyword for #{@new_resource.name} in /etc/portage/package.#{@element} has been created")
    new_resource.updated_by_last_action(true)
  else
    # pkgが存在していればupdateする
    action_update
  end
end

def action_update
  # 既存keywordの存在している添字番号
  keyword_index = find_index

  if keyword_index.nil?
    action_create
  else
    newkeyword = "#{@new_resource.name} #{@new_resource.keyword}"

    # 同じなら何もしない
    unless @keywords[keyword_index] == newkeyword
      @keywords[keyword_index] = newkeyword
      write_new_resource
      new_resource.updated_by_last_action(true)
      Chef::Log.info("Keyword for #{@new_resource.name} in /etc/portage/package.#{@element} has been updated")
    end
  end
end

def action_delete
  # 既存keywordの存在している添字番号
  keyword_index = find_index

  unless keyword_index.nil?
    @keywords.delete_at(keyword_index)
    write_new_resource
    new_resource.updated_by_last_action(true)
    Chef::Log.info("Keyword for #{@new_resource.name} in /etc/portage/package.#{@element} has been deleted")
  end
end
