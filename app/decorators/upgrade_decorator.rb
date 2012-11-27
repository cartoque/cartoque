class UpgradeDecorator < ResourceDecorator
  decorates :upgrade

  def postit_or_link
    params = { commentable_type: model.class.to_s, commentable_id: model.id, back_url: h.url_for(h.params) }
    if model.postit.present?
      h.link_to h.image_tag("note.png", size: "16x16", class: "action"),
                h.edit_postit_path(model.postit.id, params),
                class: "has-postit", data: { content: model.postit.content },
                remote: true
    else
      h.link_to h.image_tag("note_add.png", size: "16x16", class: "action showhover"),
                h.new_postit_path(params),
                remote: true
    end
  end
end
