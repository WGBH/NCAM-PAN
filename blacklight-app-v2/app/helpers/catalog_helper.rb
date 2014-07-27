module CatalogHelper
 include Blacklight::CatalogHelperBehavior

  ##
  # auto-focus the user's cursor into the searchbox
  # 
  # @return [Boolean]
  def should_autofocus_on_search_box?
    true
  end
end