module CouchRest
  class Pager
    attr_accessor :db
    def initialize db
      @db = db
    end
    
    def all_docs(count=100, &block)
      startkey = nil
      oldend = nil
      
      while docrows = request_all_docs(count+1, startkey)        
        startkey = docrows.last['key']
        docrows.pop if docrows.length > count
        if oldend == startkey
          break
        end
        yield(docrows)
        oldend = startkey
      end
    end
    
    def key_reduce(view, count, firstkey = nil, lastkey = nil, &block)
      # start with no keys
      startkey = firstkey
      # lastprocessedkey = nil
      keepgoing = true
      
      while keepgoing && viewrows = request_view(view, count, startkey)
        startkey = viewrows.first['key']
        endkey = viewrows.last['key']

        if (startkey == endkey)
          # we need to rerequest to get a bigger page
          # so we know we have all the rows for that key
          viewrows = @db.view(view, :key => startkey)['rows']
          # we need to do an offset thing to find the next startkey
          # otherwise we just get stuck
          lastdocid = viewrows.last['id']
          fornextloop = @db.view(view, :startkey => startkey, :startkey_docid => lastdocid, :count => 2)['rows']

          newendkey = fornextloop.last['key']
          if (newendkey == endkey)
            keepgoing = false
          else
            startkey = newendkey
          end
          rows = viewrows
        else
          rows = []
          for r in viewrows
            if (lastkey && r['key'] == lastkey)
              keepgoing = false
              break
            end
            break if (r['key'] == endkey)
            rows << r
          end   
          startkey = endkey
        end
        
        key = :begin
        values = []

        rows.each do |r|
          if key != r['key']
            # we're on a new key, yield the old first and then reset
            yield(key, values) if key != :begin
            key = r['key']
            values = []
          end
          # keep accumulating
          values << r['value']
        end
        yield(key, values)

      end
    end

    private
    
    def request_all_docs count, startkey = nil
      opts = {}
      opts[:count] = count if count
      opts[:startkey] = startkey if startkey      
      results = @db.documents(opts)
      rows = results['rows']
      rows unless rows.length == 0
    end

    def request_view view, count = nil, startkey = nil, endkey = nil
      opts = {}
      opts[:count] = count if count
      opts[:startkey] = startkey if startkey
      opts[:endkey] = endkey if endkey
      
      results = @db.view(view, opts)
      rows = results['rows']
      rows unless rows.length == 0
    end

  end
end