#encoding: utf-8
require 'find'

class ToolsController < ApplicationController
  def cluster_symetry
    symetry_for(/sgbd-/)
    @title = "serveurs SGBD"
    render 'servers_symetry'
  end

  def acai_symetry
    symetry_for(/^(vm|vip)-(preprod|prod|ecole|web)|^(lb-)/)
    @title = "serveurs ACAI"
    render 'servers_symetry'
  end

  def infra_symetry
    symetry_for(/supervision|nagios|tnas/)
    @title = "serveurs d'infrastructure"
    render 'servers_symetry'
  end

  def nagios_comparison
    path = Rails.root.join("data/nagios")
    servers_nagios = %x(grep host_name= #{path}/status.dat|cut -d"=" -f 2|sort -u).split(/\n/)
    # service checks that can't be renamed easily in nagios
    servers_nagios.reject!{|h| h.match(/^(VIPS?\d*_|GW_|URL_|sgbd-prod[abc]$|sgbd-prod[abc]-[a-z])/) }
    servers_nagios.each{|h| h.gsub!(/^(MIN_|RH_|RITAC_|AM_|DEV_)/,"") }
    servers_cartocs = Server.all

    @unknown_in_nagios = servers_cartocs.map(&:name) - servers_nagios
    #RH project we're not responsible of
    @unknown_in_nagios.reject!{ |name| name.starts_with?("vm-hra") || name.starts_with?("vm-hrw") }
    #Windows servers we're not responsible of
    @unknown_in_nagios.reject!{ |name| name.match(/millos|ritac-|-nt-|-ac-|^dns-[01]$/) }
    @unknown_in_cartocs = servers_nagios - servers_cartocs.map(&:name)

    tomcats_jason = Tomcat.all.map{|t| t[:tomcat]+"@"+t[:server]}.select{|t| t.match(/\S@\S/)}
    tomcats_nagios = []; prev=""
    datafile = "#{Rails.root}/data/nagios/status.dat"
    File.open(datafile).each_line do |line|
      tomcats_nagios << line.split("PROCESS_").last.chomp + "@" + prev.split("=").last.chomp if "PROCESS_TC".in?(line)
      prev=line
    end if File.exists?(datafile)
    @tomcat_unknown_in_nagios = tomcats_jason - tomcats_nagios
    @tomcat_unknown_in_nagios.reject!{|t| t.match(/vm-preprod/) }
    @nb_tomcats = tomcats_jason.reject{|t| t.match(/vm-preprod/) }.count
  end

  def reverse_proxies_comparison
    path = Rails.root.join("data/rp")
    @vhosts_lines = %x(grep -rHE '^\s*ServerName' #{path} |grep -v sites-available|sort -u 2>/dev/null).split(/\n+/)
    vhosts = @vhosts_lines.map{|line| line.scan(/ServerName\s+(\S+)/).first.first}.flatten.compact.uniq

    app_urls = ApplicationUrl.all.map(&:url).map{|u| u.strip.gsub(%r{\S+://},"").gsub(%r{/.*},"")}

    @unknown_in_cartocs = vhosts - app_urls
  end

  protected
  def symetry_for(mask)
    path = Rails.root.join("data/symetry")
    @clusters = {}
    @cluster_names = []
    Dir.glob("#{path}/*").map{|c| File.basename(c)}.sort.each do |cluster|
      next unless cluster.match(mask)
      @cluster_names << cluster
      next unless cluster == params[:id] || params[:id] == "all"
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
  end
end
