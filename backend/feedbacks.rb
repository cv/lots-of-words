class Feedbacks < Application
  
  def create
    $couchdb.database('feedback').save(
      :uri => request.uri,
      :comment => params[:comment],
    )
    redirect request.uri
  end
  
end