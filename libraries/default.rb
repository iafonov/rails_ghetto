class Chef
  class Recipe
    def rails_applications(&block)
      Array(node['rails_ghetto']['applications']).each do |application|
        application_name = application.keys.first
        application_data = application[application_name]
        default = application == Array(node['rails_ghetto']['applications']).first

        block.call(application_name, application_data, default)
      end
    end
  end
end