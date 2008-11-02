class LotsOfWords < Application
  
  def index
    if params[:source] && params[:target] && params[:term]
      redirect url(:link, {
        :source => params[:source],
        :target => params[:target],
        :term => params[:term],
      }), :permanent => true
    end
    render
  end
  
end