class Feedbacks < Application
  
  def create
    $couchdb.database('feedback').save({
      :uri => params[:uri],
      :comment => params[:comment],
    })

    redirect request.uri
  end
  
end