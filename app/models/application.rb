class Application < ActiveRecord::Base
  attr_accessible :appli_nom, :appli_criticite, :appli_info, :appli_iaw, :appli_pe, :appli_moa, :appli_amoa, :appli_moa_note, :appli_contact, :appli_pnd, :appli_ams, :appli_cerbere, :appli_fiche
end
