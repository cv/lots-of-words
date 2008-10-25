CouchRest::Model.default_database = CouchRest.database!('lexicon')

class Term < CouchRest::Model
  key_accessor :source_language, :target_language, :source_word, :target_word
end