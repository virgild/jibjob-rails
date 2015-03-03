if Rails.env.development?
  class Object
    def own_methods
      self.public_methods - Object.methods
    end
  end
end