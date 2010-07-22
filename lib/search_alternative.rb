require 'search_methods'

ActionView::Base.send :include, SearchAlternativeHelpers
ActiveRecord::Base.send :extend, SearchMethods
