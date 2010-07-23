module SearchMethods
  def search(params = {})
    search_ordering= params && params[:search] ? params[:search][:ordering] : nil
    @search_ordering = search_ordering.to_s
    search_ordering = /^asc/.match(search_ordering) ? 'ASC' : 'DESC'

    @search_by = params[:search] ? params[:search][:with] : nil
    #search_by = params && params[:search] ? params[:search][:by] : nil
    build_where(@search_by).build_order(search_ordering, ordering_by(@search_ordering))
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
      search_by.each do |key,value|
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