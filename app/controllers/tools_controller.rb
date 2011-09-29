require 'find'

class ToolsController < ApplicationController
  def cluster_symetry
    path = Rails.root.join("data/symetry")
    @clusters = {}
    Dir.glob("#{path}/*").map{|c| File.basename(c)}.sort.each do |cluster|
      @clusters[cluster] = { :path => "#{path}/#{cluster}",
                            :nodes => Dir.glob("#{path}/#{cluster}/*").map{|c| File.basename(c)}.sort }
      files = []
      lists = []
      Find.find(@clusters[cluster][:path]).each do |file|
        if file.ends_with?(".list")
          lists << file.sub(@clusters[cluster][:path],"").sub(%r{^/[^/]+},"")
        elsif File.file?(file)
          files << file.sub(@clusters[cluster][:path],"").sub(%r{^/[^/]+},"")
        end
      end
      @clusters[cluster][:files] = files.sort.uniq
      @clusters[cluster][:lists] = lists.reject{|f| f.ends_with?("packages.list")}.sort.uniq
    end
    @cluster_names = @clusters.keys
    #limit clusters
    @clusters.reject! do |cluster,hsh|
      cluster != params[:id]
    end unless params[:id] == "all"
  end
end
