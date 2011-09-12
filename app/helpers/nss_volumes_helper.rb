module NssVolumesHelper
  include SizeHelper

  def options_for_falconstor_type(selected = nil)
    options_for_select(
      ([""] + NssVolume.all.map(&:falconstor_type)).uniq.sort.map{|v| [v, v]},
      selected
    )
  end
end
