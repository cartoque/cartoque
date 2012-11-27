class Postit
  include Mongoid::Document
  field :content, type: String
  embedded_in :commentable, polymorphic: true

  def to_s
    commentable.to_s
  end
end
