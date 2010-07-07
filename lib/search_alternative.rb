ActiveRecord::Base.class_eval do
  def self.search(params = {})
    search_ordering= params && params[:search] ? params[:search][:ordering] : nil
    @search_ordering = search_ordering.to_s
    search_ordering = /^asc/.match(search_ordering) ? 'ASC' : 'DESC'
    #search_by = params && params[:search] ? params[:search][:by] : nil
    where('TRUE').build_order(search_ordering, ordering_by(@search_ordering))
  end

  def self.build_order(search_ordering, search_by)
    if search_ordering && search_by
      order("#{search_by} #{search_ordering}")
    else
      order ''
    end
  end

  def self.ordering
    @search_ordering
  end

# Returns the column we are currently ordering by
  def self.ordering_by(ordering)
    ordering && ordering.to_s.gsub(/^(ascend|descend)_by_/, '')
  end
end
