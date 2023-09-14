# frozen_string_literal: true

describe Octokit::Client::ActionsVariables do
  before do
    Octokit.reset!
    @client = oauth_client
    @variables = [{ name: 'variable_name', value: 'variable_value' }, { name: 'variable_name2', value: 'variable_value2' }]
  end

  context 'with a repo' do
    before(:each) do
      @repo = @client.create_repository('variable-repo')
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end
  end

  context 'with a repo without variables' do
    before(:each) do
      @repo = @client.create_repository('secret-repo')
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.list_actions_variables', :vcr do
      it 'returns empty list of variables' do
        variables = @client.list_actions_variables(@repo.id)
        expect(variables.total_count).to eq(0)
        expect(variables.variables).to be_empty
      end
    end # .list_actions_variables

    describe '.create_actions_variable', :vcr do
      it 'creating variable returns 201' do
        @client.create_actions_variable(
          @repo.id,
          name: @variables.first[:name], value: @variables.first[:value]
        )
        expect(@client.last_response.status).to eq(201)
      end
    end # .create_actions_variable
  end

  context 'with an environment without a variable' do
    before(:each) do
      @repo = @client.create_repository('variable-repo')
      @client.create_or_update_environment(@repo.id, 'zero')
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.list_actions_environment_variables', :vcr do
      it 'returns empty list of variables' do
        variables = @client.list_actions_environment_variables(@repo.id, 'zero')
        expect(variables.total_count).to eq(0)
        expect(variables.variables).to be_empty
      end
    end # .list_actions_environment_variables

    describe '.create_actions_environment_variable', :vcr do
      it 'creating variable returns 201' do
        @client.create_actions_environment_variable(
          @repo.id, 'zero',
          name: @variables.first[:name], value: @variables.first[:value]
        )
        expect(@client.last_response.status).to eq(201)
      end
    end # .create_actions_environment_variable
  end

  context 'with a repository with a variable' do
    before(:each) do
      @repo = @client.create_repository('variable-repo')
      @variables.each do |variable|
        @client.create_actions_variable(
          @repo.id,
          name: variable[:name], value: variable[:value]
        )
      end
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.list_actions_variables', :vcr do
      it 'returns list of two variables' do
        variables = @client.list_actions_variables(@repo.id)
        expect(variables.total_count).to eq(2)
        expect(variables.variables[0].name).to eq(@variables.first[:name].upcase)
      end

      it 'paginates the results' do
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        variables = @client.list_actions_variables(@repo.id)

        expect(@client).to have_received(:paginate)
        expect(variables.total_count).to eq(2)
        expect(variables.variables.count).to eq(1)
      end

      it 'auto-paginates the results' do
        @client.auto_paginate = true
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        variables = @client.list_actions_variables(@repo.id)

        expect(@client).to have_received(:paginate)
        expect(variables.total_count).to eq(2)
        expect(variables.variables.count).to eq(2)
      end
    end # .list_actions_variables

    describe '.get_actions_variable', :vcr do
      it 'return timestamps related to one variable' do
        received = @client.get_actions_variable(@repo.id, @variables.first[:name])
        expect(received.name).to eq(@variables.first[:name].upcase)
      end
    end # .get_actions_variable

    describe '.update_actions_variable', :vcr do
      it 'updating existing variable returns 204' do
        @client.update_actions_variable(
          @repo.id, @variables.first[:name],
          name: @variables.first[:name], value: 'new-value'
        )
        expect(@client.last_response.status).to eq(204)
      end
    end # .update_actions_variable

    describe '.delete_actions_variable', :vcr do
      it 'delete existing variable' do
        @client.delete_actions_variable(@repo.id, @variables.first[:name])
        expect(@client.last_response.status).to eq(204)
      end
    end
  end

  context 'with a repository environment with a variable' do
    before(:each) do
      @repo = @client.create_repository('variable-repo')
      @client.create_or_update_environment(@repo.id, 'production')
      @variables.each do |variable|
        @client.create_actions_environment_variable(
          @repo.id, 'production',
          name: variable[:name], value: variable[:value]
        )
      end
    end

    after(:each) do
      @client.delete_repository(@repo.full_name) unless @repo.nil?
    rescue Octokit::NotFound
    end

    describe '.list_actions_environment_variables', :vcr do
      it 'returns list of two variables' do
        variables = @client.list_actions_environment_variables(@repo.id, 'production')
        expect(variables.total_count).to eq(2)
        expect(variables.variables[0].name).to eq(@variables.first[:name].upcase)
      end

      it 'paginates the results' do
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        variables = @client.list_actions_environment_variables(@repo.id, 'production')

        expect(@client).to have_received(:paginate)
        expect(variables.total_count).to eq(2)
        expect(variables.variables.count).to eq(1)
      end

      it 'auto-paginates the results' do
        @client.auto_paginate = true
        @client.per_page = 1
        allow(@client).to receive(:paginate).and_call_original
        variables = @client.list_actions_environment_variables(@repo.id, 'production')

        expect(@client).to have_received(:paginate)
        expect(variables.total_count).to eq(2)
        expect(variables.variables.count).to eq(2)
      end
    end # .list_actions_environment_variables

    describe '.get_actions_environment_variable', :vcr do
      it 'return timestamps related to one variable' do
        received = @client.get_actions_environment_variable(@repo.id, 'production', @variables.first[:name])
        expect(received.name).to eq(@variables.first[:name].upcase)
      end
    end # .get_actions_environment_variable

    describe '.update_actions_environment_variable', :vcr do
      it 'updating existing variable returns 204' do
        @client.update_actions_environment_variable(
          @repo.id, 'production', @variables.first[:name],
          name: @variables.first[:name], value: 'new-value'
        )
        expect(@client.last_response.status).to eq(204)
      end
    end # .update_actions_environment_variable

    describe '.delete_actions_environment_variable', :vcr do
      it 'delete existing variable' do
        @client.delete_actions_environment_variable(@repo.id, 'production', @variable.first[:name])
        expect(@client.last_response.status).to eq(204)
      end
    end # .delete_actions_environment_variable
  end
end
