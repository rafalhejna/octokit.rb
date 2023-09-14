# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Actions Variables API
    #
    # @see https://docs.github.com/en/rest/actions/variables/
    module ActionsVariables
      # List variables
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Hash] total_count and list of variables (each item is a hash with name, value, created_at and updated_at)
      # @see https://docs.github.com/en/rest/actions/variables#list-repository-variables
      def list_actions_variables(repo)
        paginate "#{Repository.path repo}/actions/variables" do |data, last_response|
          data.variables.concat last_response.data.variables
        end
      end

      # Get a variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of a variable
      # @return [Hash] name, value, created_at and updated_at
      # @see https://docs.github.com/en/rest/actions/variables#get-a-repository-variable
      def get_actions_variable(repo, name)
        get "#{Repository.path repo}/actions/variables/#{name}"
      end

      # Create a variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param options [Hash] name and value
      # @see https://docs.github.com/en/rest/actions/variables#create-a-repository-variable
      def create_actions_variable(repo, options)
        post "#{Repository.path repo}/actions/variables", options
      end

      # Update a variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of variable
      # @param options [Hash] name and value
      # @see https://docs.github.com/en/rest/actions/variables#update-a-repository-variable
      def update_actions_variable(repo, name, options)
        patch "#{Repository.path repo}/actions/variables/#{name}", options
      end

      # Delete a variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] Name of variable
      # @see https://docs.github.com/en/rest/actions/variables#delete-a-repository-variable
      def delete_actions_variable(repo, name)
        boolean_from_response :delete, "#{Repository.path repo}/actions/variables/#{name}"
      end

      # List environment variables
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param environment [String] Name of environment
      # @return [Hash] total_count and list of variables (each item is hash with name, value, created_at and updated_at)
      # @see https://docs.github.com/en/rest/actions/variables#list-environment-variables
      def list_actions_environment_variables(repo, environment)
        paginate "#{Repository.path repo}/environments/#{environment}/variables" do |data, last_response|
          data.variables.concat last_response.data.variables
        end
      end

      # Get an environment variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param environment [String] Name of environment
      # @param name [String] Name of variable
      # @return [Hash] name, value, created_at and updated_at
      # @see https://docs.github.com/en/rest/actions/variables#get-an-environment-variable
      def get_actions_environment_variable(repo, environment, name)
        get "#{Repository.path repo}/environments/#{environment}/variables/#{name}"
      end

      # Create an environment variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param environment [String] Name of environment
      # @param options [Hash] name and value
      # @see https://docs.github.com/en/rest/actions/variables#create-an-environment-variable
      def create_actions_environment_variable(repo, environment, options)
        post "#{Repository.path repo}/environments/#{environment}/variables", options
      end

      # Update an environment variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param environment [String] Name of environment
      # @param name [String] Name of variable
      # @param options [Hash] name and value
      # @see https://docs.github.com/en/rest/actions/variables#update-an-environment-variable
      def update_actions_environment_variable(repo, environment, name, options)
        patch "#{Repository.path repo}/environments/#{environment}/variables/#{name}", options
      end

      # Delete an environment variable
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param environment [String] Name of environment
      # @param name [String] Name of variable
      # @see https://docs.github.com/en/rest/actions/variables#delete-an-environment-variable
      def delete_actions_environment_variable(repo, environment, name)
        boolean_from_response :delete, "#{Repository.path repo}/environments/#{environment}/variables/#{name}"
      end
    end
  end
end
