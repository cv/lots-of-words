class Languages < Application
  
  provides :json, :xml
  
  def counts
    @counts = $lexicon.view('langs/count', {:startkey => params[:language], :group => true, :count => 1})

    display @counts
  end
  
  def link_counts
    @link_counts = $lexicon.view('langs/by_target_lang', :startkey => [params[:source], params[:target]].to_json, :count => 1)
    
    display @link_counts
  end
  
  def link
    @link = $lexicon.view('langs/by_source_and_target', {
      :startkey => [params[:source], params[:target], params[:term]],
      :count => 1,
      :include_docs => true,
    })
    
    display @link
  end
  
end