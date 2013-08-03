object @tomcat

attributes :id, :name, :vip, :dns, :directory, :tomcat_version,
           :java_version, :java_xms, :java_xmx, :jdbc_url,
           :jdbc_server, :jdbc_db, :jdbc_user, :jdbc_driver,
           :cerbere, :cerbere_csac, :server_id, :server_name

#timestamps
attributes :created_at
attributes :updated_at
