# keyword��1�ѥå�����1�ĤȲ���
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
  # ��¸keyword��¸�ߤ��Ƥ���ź���ֹ�
  @keywords.find_index do |l|
    Regexp.new("^#{@new_resource.name}") =~ l
  end
end

def action_create
  # ��¸keyword��¸�ߤ��Ƥ���ź���ֹ�
  keyword_index = find_index

  if keyword_index.nil?
    # pkg��¸�ߤ��ʤ����create����
    @keywords.push "#{@new_resource.name} #{@new_resource.keyword}"
    write_new_resource
    Chef::Log.info("Keyword for #{@new_resource.name} in /etc/portage/package.#{@element} has been created")
    new_resource.updated_by_last_action(true)
  else
    # pkg��¸�ߤ��Ƥ����update����
    action_update
  end
end

def action_update
  # ��¸keyword��¸�ߤ��Ƥ���ź���ֹ�
  keyword_index = find_index

  if keyword_index.nil?
    action_create
  else
    newkeyword = "#{@new_resource.name} #{@new_resource.keyword}"

    # Ʊ���ʤ鲿�⤷�ʤ�
    unless @keywords[keyword_index] == newkeyword
      @keywords[keyword_index] = newkeyword
      write_new_resource
      new_resource.updated_by_last_action(true)
      Chef::Log.info("Keyword for #{@new_resource.name} in /etc/portage/package.#{@element} has been updated")
    end
  end
end

def action_delete
  # ��¸keyword��¸�ߤ��Ƥ���ź���ֹ�
  keyword_index = find_index

  unless keyword_index.nil?
    @keywords.delete_at(keyword_index)
    write_new_resource
    new_resource.updated_by_last_action(true)
    Chef::Log.info("Keyword for #{@new_resource.name} in /etc/portage/package.#{@element} has been deleted")
  end
end
