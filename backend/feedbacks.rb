class Feedbacks < Application
  
  def create
    $couchdb.database('feedback').save({
      :uri => params[:uri],
      :comment => params[:comment],
    })

    redirect params[:uri]
  end
  
end