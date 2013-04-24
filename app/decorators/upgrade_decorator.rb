class UpgradeDecorator < ResourceDecorator
  decorates :upgrade

  def postit_or_link
    params = { commentable_type: model.class.to_s, commentable_id: model.id, back_url: back_url }
    if model.postit.present?
      h.link_to h.image_tag("note.png", size: "16x16", class: "action"),
                h.edit_postit_path(model.postit.id, params),
                class: "has-postit postit-link", data: { content: model.postit.content },
                remote: true
    else
      h.link_to h.image_tag("note_add.png", size: "16x16", class: "action showhover"),
                h.new_postit_path(params),
                class: "postit-link",
                remote: true
    end
  end

  def pretty_rebootable?
    if model.rebootable?
      h.content_tag(:span, t(:word_yes), class: "rebootable yes")
    else
      h.content_tag(:span, t(:word_no), class: "rebootable no")
    end
  end

  def toggle_rebootable_link
    h.link_to pretty_rebootable?,
              h.upgrade_path(model, upgrade: {rebootable: !model.rebootable?}, back_url: back_url),
              method: :put, remote: true
  end

  def back_url
    h.params[:back_url] || h.url_for(h.params)
  end
end
