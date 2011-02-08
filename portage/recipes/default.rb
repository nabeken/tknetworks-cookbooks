template "/etc/portage/categories" do
  source "etc/portage/categories"
  variables :categories => node.portage.categories
end
