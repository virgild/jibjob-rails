module ModelSerialization
  extend ActiveSupport::Concern

  included do

  end

  def serialize_model(object, opts={})
    ActiveModel::Serializer.serializer_for(object).new(object, opts)
  end

end