# Rails Ghetto

Description
===========

Chef cookbook intended for managing & deployment of multiple rack-based applications living on one server behind nginx. Supports asset pipeline right from the box.

Uses nginx + unicorn to run applications.

Requirements
============

Cookbook depends on several Opscode's cookbooks:

* [application](https://github.com/opscode-cookbooks/application)
* [application_ruby](https://github.com/opscode-cookbooks/application_ruby)
* [nginx](https://github.com/opscode-cookbooks/nginx)

Recipes
=======

* `rails_ghetto::user` - creates user and group (if they aren't exist) that are used to deploy & run applications
* `rails_ghetto::nginx_sites_enable` - creates and enables nginx configuration files 
* `rails_ghetto::deploy` - deploys application. *Caution* - [revision based deploy](http://wiki.opscode.com/display/chef/Deploy+Resource#DeployResource-DeployResource) is used to ensure that chef-client runs will not re-deploy all applications. Make sure you understand how it works.

Attributes
==========

Here is a sample YAML representation of attributes hierarchy:

    rails_ghetto:
      deployment_user: deploy
      deployment_group: deploy
      apps_root: /var/www/apps
      libs:
        - libxslt-dev
        - libxml2-dev
      applications:
        sample:
          repository: git@github.com:account/application.git
          revision: master
          deploy_key: /home/root/.ssh/github
          unicorn_port: 8080
          server_name: production.example.com
          compile_assets: true
          run_migrations: true
          rails_environment: production
          database: { adapter: mysql2, encoding: utf8, database: sample, username: root, password: changeit, socket: /tmp/mysql.sock }
        sample2:
          repository: git@github.com:account/application.git
          revision: master
          deploy_key: /home/root/.ssh/github
          unicorn_port: 8081
          server_name: staging.example.com
          compile_assets: false
          run_migrations: true
          rails_environment: staging
          database: { adapter: postgresql, database: sample2, username: root, password: changeit }

Gotchas
=======

* To install additional packages that are needed to compile gem native extensions you can use `libs` attribute and specify list of dependencies. For example if you use nokogiri you'll have to additionally install `libxslt-dev` and `libxml2-dev` packages. It's a really bad idea to install anything else like runtime dependencies using this attribute you should use separate cookbooks for installing them.
* If you're deploying more than one application - you must manually set different unicorn ports for them.

© 2012 [Igor Afonov](https://iafonov.github.com) MIT License
