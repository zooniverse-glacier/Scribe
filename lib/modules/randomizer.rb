# Provides random document selection to a model
module Randomizer
  extend ActiveSupport::Concern
  
  included do
    key :random_number, Float
    before_create Proc.new{ |doc| doc.random_number = rand }
  end
  
  module ClassMethods
    # Finds sequential random documents.
    # When using the :selector option, ensure you're hitting an index that includes :random as the last listed key.
    # Additionally, do not use range queries in the selector: {http://bit.ly/gHxnLN MongoDB Indexing Advice}.
    # 
    # @param [Hash] :limit => the number of documents to find, :selector => randomly select documents matching this criteria
    # @return [Array] the randomly selected documents
    def random(*args)
      opts = { :limit => 1, :selector => { } }.update(args.extract_options!)
      
      number = rand
      criteria = where(opts[:selector]).limit(opts[:limit])
      result = criteria.all(:random_number => { :$gte => number })
      
      criteria = criteria.limit(opts[:limit] - result.length)
      result += criteria.all(:random_number => { :$lte => number }) if result.length < opts[:limit]
      result
    end
    
    # Finds non-sequential random documents.
    # When using the :selector option, ensure you're hitting an index that includes :random as the last listed key.
    # Additionally, do not use range queries in the selector: {http://bit.ly/gHxnLN MongoDB Indexing Advice}.
    # 
    # @param [Hash] :limit => the number of documents to find, :selector => randomly select documents matching the criteria
    # @return [Array] the randomly selected documents
    def really_random(*args)
      opts = { :limit => 1, :selector => { } }.update(args.extract_options!)
      
      [].tap do |results|
        opts[:limit].times do
          number = rand
          results << where(opts[:selector]).first(:random_number => { :$gte => number }) ||
                     where(opts[:selector]).first(:random_number => { :$lte => number })
        end
      end
    end
  end
end
