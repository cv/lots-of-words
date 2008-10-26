class Feedbacks < Application
  
  def create
    $couchdb.database('feedback').save({ :uri => request.uri, :comment => params[:comment], :created_at => Time.now })
    redirect request.uri
  end
  
end