define :portage, :keyword => nil, :mask => nil, :unmask => nil, :use_enable => nil, :use_disable => nil do
    templates = {}

    [:mask, :unmask, :use, :keywords].each do |t|
        templates[t] = resources(:template => "/etc/portage/package.#{t}")
    end

    Chef::Log.info(templates[:use].variables.inspect)

    # /etc/portage/package.keywords
    unless params[:keywords].nil?
        templates[:keywords].variables[:keywords] += params[:keywords].to_a.map do |k|
            "#{params[:name]} #{k}"
        end
    end

    # /etc/portage/package.use
    unless params[:use_enable].nil?
        templates[:use].variables[:use][params[:name]] = [] if templates[:use].variables[:use][params[:name]].nil?
        templates[:use].variables[:use][params[:name]] += params[:use_enable].to_a
    end

    unless params[:use_disable].nil?
        templates[:use].variables[:use][params[:name]] = [] if templates[:use].variables[:use][params[:name]].nil?
        templates[:use].variables[:use][params[:name]] += params[:use_disable].to_a.map do |u| "-#{u}" end
    end

    # /etc/portage/package.{mask,unmask}
    [:mask, :unmask].each do |p|
        unless params[p].nil?
            templates[p].variables[p] += params[p].to_a.map do |m|
                m =~ /(>=|<=|=|>|<)(.*)/
                "#{$1}#{params[:name]}-#{$2}"
            end
        end
    end

end
