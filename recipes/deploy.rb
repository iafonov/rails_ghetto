deployment_user  = node['rails_ghetto']['deployment_user']
deployment_group = node['rails_ghetto']['deployment_group']

Array(node['rails_ghetto']['libs']).each do |lib|
  package lib
end

rails_applications do |name, app|
  application name do
    path "/var/www/apps/#{name}"
    owner deployment_user
    group deployment_group
    deploy_key File.read(app['deploy_key']) if app['deploy_key']

    before_symlink do
      # TODO: figure out how to extract common part
      if app['run_migrations']
        execute 'create_and_migrate_database' do
          command 'bundle exec rake db:create db:migrate'
          user deployment_user
          group deployment_group
          cwd release_path
          environment ({'RAILS_ENV' => app['rails_environment']})
        end
      end

      if app['compile_assets']
        execute 'compile_assets' do
          command 'bundle exec rake assets:precompile'
          user deployment_user
          group deployment_group
          cwd release_path
          environment ({'RAILS_ENV' => app['rails_environment']})
        end
      end
    end

    repository app['repository']
    revision app['revision']

    rails do
      gems ['bundler', 'rake']

      if app.has_key? 'database'
        database do
          app['database'].each do |key, value|
            send(key.to_sym, value)
          end
        end
      end
    end

    unicorn do
      port app['unicorn_port'].to_s
      restart_command do
        execute "/etc/init.d/#{name} restart" do
        end
      end
    end
  end
end