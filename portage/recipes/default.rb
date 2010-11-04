# initialize template resources
[:mask, :unmask, :use, :keywords].each do |t|
    var = case t
         when :use
             {}
         else
             []
         end

    template "/etc/portage/package.#{t}" do 
        source "etc/portage/package.#{t}"
        variables t => var
    end
end
