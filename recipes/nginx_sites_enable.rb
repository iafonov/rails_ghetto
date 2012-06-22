nginx_site "default" do
  enable false
end

rails_applications do |name, data, default|
  template "/etc/nginx/sites-available/#{name}" do
    source "nginx_site.erb"
    mode 644
    variables(
      :application_name => name,
      :default => default,
      :unicorn_port => data["unicorn_port"]
    )
  end

  nginx_site name do
    enable true
  end
end