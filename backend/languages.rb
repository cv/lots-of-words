class Languages < Application
  
  # match('/:language').            to(:controller => "languages",     :action => 'counts').     name(:counts)
  # match('/:source/:target').      to(:controller => "languages",     :action => 'link_counts').name(:link_counts)
  # match('/:source/:target/:term').to(:controller => "languages",     :action => 'link').       name(:links)

  def counts
    render
  end
  
  def link_counts
    render
  end
  
  def links
    render
  end
  
end