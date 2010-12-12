define :apache2_domain, :owner => nil, :group => nil do
  # htdocsやログ出力先の準備
  [node.apache2.htdocs, node.apache2.logs].each do |d|
    directory "#{d}/#{params[:name]}" do
      action :create
      owner params[:owner]
      group params[:group]
      mode "0770"
    end
  end
end
