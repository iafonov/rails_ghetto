group node["rails_ghetto"]["deployment_group"]

user node["rails_ghetto"]["deployment_user"] do
  comment "Deployment User"
  home "/home/#{node["rails_ghetto"]["deployment_user"]}"
  gid node["rails_ghetto"]["deployment_group"]
  supports :manage_home => true
end

directory "/home/deploy/.ssh" do
  owner node["rails_ghetto"]["deployment_user"]
  group node["rails_ghetto"]["deployment_group"]
  mode 0700
  recursive true
end

file "/home/deploy/.ssh/authorized_keys" do
  owner node["rails_ghetto"]["deployment_user"]
  group node["rails_ghetto"]["deployment_group"]
  mode 0600
  content Array(node["rails_ghetto"]["authorized_keys"]).join("\n")
end