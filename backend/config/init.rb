use_test :rspec
use_template_engine :haml

require 'couchrest'

require 'application'
require 'lots_of_words'
require 'languages'
require 'feedbacks'

Merb::BootLoader.before_app_loads do
  $couchdb = CouchRest.new('http://lotsofwords.com:5984')
  $lexicon = $couchdb.database('lexicon')
end
 
Merb::BootLoader.after_app_loads do
end

Merb::Router.prepare do
  match('/').                               to(:controller => "lots_of_words", :action => 'index').      name(:home)
  match('/feedbacks(.:format)')            .to(:controller => "feedbacks",     :action => 'create').     name(:feedbacks)
  match('/:language(.:format)').            to(:controller => "languages",     :action => 'counts').     name(:counts)
  match('/:source/:target(.:format)').      to(:controller => "languages",     :action => 'link_counts').name(:link_counts)
  match('/:source/:target/:term(.:format)').to(:controller => "languages",     :action => 'link').       name(:link)
end

Merb::Config.use {|c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :debug,
  c[:log_stream]          = STDOUT,
  c[:log_file]            = Merb.root / "log" / "merb.log",
  c[:use_mutex]           = true,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_session_id',
  c[:session_secret_key]  = '29e206ab84fde81c66d6a36904a7a27d9ecb0b25',
  c[:exception_details]   = true,
  c[:reload_classes]      = true,
  c[:reload_templates]    = true,
  c[:reload_time]         = 0.5
}
