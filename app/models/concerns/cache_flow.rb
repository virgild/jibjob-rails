module CacheFlow
  extend ActiveSupport::Concern

  module ClassMethods
    # Creates a cache key strategy for an ActiveRecord model relationship.
    # It results in the model instances having a 'cached_[relation_]' method.
    def has_cache(relation, opts = {})
      elements = opts.delete(:with_elements)
      model = self.table_name

      # def cached_relation
      define_method "cached_#{relation}".to_sym, -> (&blk) {
        raise "Needs block" if blk.nil?

        key_elements = [
          [model, self.id],
          relation
        ].concat(elements.map { |name, meth| "#{name}:#{meth.call(self)}" })

        key = key_elements.map { |item| item.is_a?(Enumerable) ? item.join(':') : item }.join('-')

        Rails.cache.fetch(key) do
          blk.yield
        end
      }

      #
    end
  end
end