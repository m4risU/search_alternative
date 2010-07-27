module SearchAlternativeHelpers
  def order(search, options = params[:search], html_options = {}, page = params[:page], page_params = params)

    url_options = {
                          :search => {}
    }

    if options && options[:by]
      options[:params_scope] ||= :search
      if !options[:as]
        id = options[:by].to_s.downcase == "id"
        options[:as] = id ? options[:by].to_s.upcase : options[:by].to_s.humanize
      end
      options[:ascend_scope] ||= "ascend_by_#{options[:by]}"
      options[:descend_scope] ||= "descend_by_#{options[:by]}"
      ascending = search.ordering.to_s == options[:ascend_scope]
      new_scope = ascending ? options[:descend_scope] : options[:ascend_scope]
      selected = [options[:ascend_scope], options[:descend_scope]].include?(search.ordering.to_s)
      if selected
        css_classes = html_options[:class] ? html_options[:class].split(" ") : []
        if ascending
          options[:as] = raw "&#9650;&nbsp;#{options[:as]}"
          css_classes << "ascending"
        else
          options[:as] = raw "&#9660;&nbsp;#{options[:as]}"
          css_classes << "descending"
        end
        html_options[:class] = css_classes.join(" ")
      end
      #url_options = {
      #        options[:params_scope] => search.conditions.merge({:ordering => new_scope})
      #}.deep_merge(options[:params] || {})

      url_options =
              {
                      options[:params_scope] => {:ordering => new_scope}
              }

    end

    if options && options[:by_scope]
      url_options[:search][:by_scope] = options[:by_scope]


      if page_params[:search] && page_params[:search][:by_scope] == options[:by_scope]

        css_classes = html_options[:class] ? html_options[:class].split(" ") : []
        if page_params[:search] && page_params[:search][:scope_direction] == "ascending"
          options[:as] = raw "&#9660;&nbsp;#{options[:as]}"
          css_classes << "descending"
        else
          options[:as] = raw "&#9650;&nbsp;#{options[:as]}"
          css_classes << "ascending"
        end
        html_options[:class] = css_classes.join(" ")
      end

      if page_params[:search] && page_params[:search][:scope_direction] == "ascending"
        url_options[:search][:scope_direction] = "descending"

      else
        url_options[:search][:scope_direction] = "ascending"

      end
    end

    if page
      url_options[:page] = page
    end
    if page_params[:search]
      if page_params[:search][:with]
        url_options[:search][:with] = page_params[:search][:with]
      end
      if page_params[:search][:role_name]
        url_options[:search][:role_name] = page_params[:search][:role_name]
      end
      if page_params[:search][:role_object]
        url_options[:search][:role_object] = page_params[:search][:role_object]
      end
      if page_params[:search][:filter]
        url_options[:search][:filter] = page_params[:search][:filter]
      end
      if page_params[:search][:filter_params]
        url_options[:search][:filter_params] = page_params[:search][:filter_params]
      end
#      if page_params[:search][:by_scope]
#        url_options[:search][:by_scope] = page_params[:search][:by_scope]
#      end
#      if page_params[:search][:scope_direction]
#        url_options[:search][:scope_direction] = page_params[:search][:scope_direction]
#      end
    end

    options[:as] = raw(options[:as]) if defined?(RailsXss)

    link_to options[:as], url_for(url_options), html_options
  end

  def filter(filter_scope, options = params[:search], html_options = {}, page_params = params)
    url_options = {
                          :search => {}
    }
    if filter_scope
      url_options[:search][:filter] = filter_scope
      if options[:filter_params]
        url_options[:search][:filter_params] = options[:filter_params]
      end
    end
    if page_params[:search]
      if page_params[:search][:with]
        url_options[:search][:with] = page_params[:search][:with]
      end
      if page_params[:search][:role_name]
        url_options[:search][:role_name] = page_params[:search][:role_name]
      end
      if page_params[:search][:role_object]
        url_options[:search][:role_object] = page_params[:search][:role_object]
      end
      if page_params[:search][:by_scope]
        url_options[:search][:by_scope] = page_params[:search][:by_scope]
      end
      if page_params[:search][:scope_direction]
        url_options[:search][:scope_direction] = page_params[:search][:scope_direction]
      end
    end

    link_to options[:as], url_for(url_options), html_options
  end

  def search_tag(search_by_field, options = params)
    value = ''
    if options[:search]
      if options[:search][:with]
        value = options[:search][:with][search_by_field.to_sym]
      end
    end
    text_field_tag "search[with][#{search_by_field}]", value.to_s
  end

end