package "app-text/lv" do
  action :install
end

#portage_keywords "app-text/lv" do
#  keyword "~amd64"
#  action :delete
#  notifies :reinstall, resources(:package => "app-text/lv")
#end

#portage_unmask "app-text/lv" do
#  versions %w(=9999 =8888)
#  action :delete
#  notifies :reinstall, resources(:package => "app-text/lv")
#end

portage_use "app-text/lv" do
  enable  %w(cjk hoge xxx)
  disable %w(xxxx yyyy zzzz)
  action :delete
  notifies :reinstall, resources(:package => "app-text/lv")
end
