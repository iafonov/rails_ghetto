class Chef
  class Recipe
    def rails_applications(&block)
      node['rails_ghetto']['applications'].each do |application_name, application_data|
        default = application_name == node['rails_ghetto']['applications'].keys.first

        block.call(application_name, application_data, default)
      end
    end
  end
end