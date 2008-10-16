#!/usr/bin/env ruby
#
# A HORRIFYING WIKIPEDIA DUMP IMPORTER FOR COUCHDB
#
# Are you sitting down? Good.
# 
# This needs: curl, bzegrep, sed, egrep and a healthy wikipedia pages-articles dump 
# file, which will be grabbed for you if you supply a language code in ARGV[0].
# 
# On my machine, it's converted the whole PT dump in 1m22s. YMMV.
#
# TODO: stop being a lazy bastard and use IO.popen - should improve speed considerably

unless ARGV[0]
  $stderr.puts 'usage: ruby omfg.rb [LANG CODE TO IMPORT] {FILE TO IMPORT}'
  exit
end

require 'rubygems'
require 'couchrest'
require 'date'
require 'yaml'

source_language = ARGV[0]
file = ARGV[1] || "http://download.wikimedia.org/#{source_language}wiki/latest/#{source_language}wiki-latest-pages-articles.xml.bz2"
$stderr.puts "#{Time.now}: Processing #{source_language} pages from #{file}..."

input = nil

if ARGV[1]
  input = IO.popen("bzegrep '(^\\[\\[[a-z]{2,3}:(.*?)\\]\\])|<title>' #{file} |
          sed 's/<title>/TITLE:/g' | 
          sed 's/<\\/title>//g' | 
          egrep '(^\\[\\[[a-z]{2,3}:(.*?)\\]\\])|TITLE' | 
          sed 's/\\[\\[//g' | 
          sed 's/\\]\\]//g' | 
          sed 's/ *TITLE/TITLE/g' |
          sed 's/<\\/text>//g'")
else
  input = IO.popen("curl #{file} |
          bzegrep '(^\\[\\[[a-z]{2,3}:(.*?)\\]\\])|<title>' |
          sed 's/<title>/TITLE:/g' | 
          sed 's/<\\/title>//g' | 
          egrep '(^\\[\\[[a-z]{2,3}:(.*?)\\]\\])|TITLE' | 
          sed 's/\\[\\[//g' | 
          sed 's/\\]\\]//g' | 
          sed 's/ *TITLE/TITLE/g' |
          sed 's/<\\/text>//g'")
end

last_title = nil

couch = CouchRest.new('http://localhost:5984')

begin
  db = couch.database('lexicon')
rescue
  db = couch.create_db('lexicon')
  db.save({ "_id"  => "_design/langs",
           "language" => "javascript",
           "views" => {
             "count" => {
               "map"    => "function(doc) { emit(doc.target_language, 1); }",
               "reduce" => "function(k,v,c) { return sum(v);}"
             },            
             "translation-count" => {
               "map" => "function(doc) { emit(doc.source_word, 1);}",
               "reduce" => "function(k,v,c) { return sum(v);}"
             },
             "by_source" => {
               "map" => "function(doc) { emit(doc.source_word, doc);}"
             },
             "by_target" => {
               "map" => "function(doc) { emit(doc.target_word, doc);}"
             },
             "by_target_lang" => {
               "map" => "function(doc) { emit(doc.target_language, doc);}"
             }
           }
        })
end

docs = []

$stderr.puts "#{Time.now}: START!"

input.each_line do |line| 
  parts = line.split(':')
  target_language = parts.shift
  target = parts.join(':')

  if target_language == 'TITLE'
    last_title = target
  else 
    source_word = last_title.tr("\n",'').tr("'",'')
    target_word = target.tr("\n", '').tr("'",'')
  
    docs << {
      :source_language => source_language,
      :source_word => source_word,
      :target_language => target_language,
      :target_word => target_word           
    }
  
    if docs.size == 2500
      begin
        db.bulk_save docs
        putc '.'
      rescue => e
       docs.each do |doc| 
         begin
           db.save doc
           putc '-'
         rescue => e
            putc '!'
         end
       end
      end
      # refresh the views
     `curl -s "http://localhost:5984/lexicon/_view/langs/count?group=true"`
      docs = []
    end
  end
end

input.close

$stderr.puts "#{Time.now}: DING!"
