module SearchMethods
  def search(params = {})
    if params && params[:search]
      search_ordering= params && params[:search] ? params[:search][:ordering] : nil
      @search_ordering = search_ordering.to_s
      search_ordering = /^asc/.match(search_ordering) ? 'ASC' : 'DESC'
      @search_by = params[:search] ? params[:search][:with] : nil
      #search_by = params && params[:search] ? params[:search][:by] : nil

      build_where(@search_by).build_order(search_ordering, ordering_by(@search_ordering)).use_search_scope(params[:search]).use_search_filter_scope(params[:search]).use_search_filters(params[:search][:search_filters])
    else
      where("true")
    end
  end

  def use_search_scope(search_params)
    if search_params[:by_scope] && search_params[:scope_direction]
      send("#{search_params[:scope_direction]}_by_#{search_params[:by_scope]}")
    else
      where("true")
    end
  end

  def use_search_filter_scope(search)
    if search[:filter]
      send("filter_by_#{search[:filter]}".to_sym, search[:filter_params] ? search[:filter_params] : nil)
    else
      where("true")
    end
  end

  def use_search_filters(search_hash)
    searches = search_hash.clone if search_hash

    if searches && !searches.empty?
      key, value = searches.shift
      anonymous_filter =
              lambda {
                send("filter_by_#{key}".to_sym, value).use_search_filters(searches)
              }
      anonymous_filter.call
    else
      where("true")
    end
  end

  def build_order(search_ordering, search_by)
    if search_ordering && search_by && !search_by.empty?
      scoped(:order => "#{search_by} #{search_ordering}")
    else
      order ''
    end
  end

  def build_where(search_by)
    result = 'TRUE'
    if search_by
      search_by.each do |key, value|
        result += " and #{key} like '%#{value}%'"
      end
    end

    where(result)
  end

  def ordering
    @search_ordering
  end

  # Returns the column we are currently ordering by
  def ordering_by(ordering)
    ordering && ordering.to_s.gsub(/^(ascend|descend)_by_/, '')
  end
end