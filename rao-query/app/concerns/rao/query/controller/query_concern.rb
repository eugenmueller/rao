module Rao
  module Query
    module Controller
      # Example
      #
      #     # app/controllers/posts_controller.rb
      #     class PostsController < ApplicationController
      #       include Rao::Query::Controller::QueryConcern
      #
      #       def index
      #         @posts = with_conditions_from_query(Post).all
      #       end
      #     end
      #
      module QueryConcern
        extend ActiveSupport::Concern

        private

        def with_conditions_from_query(scope)
          if query_params.keys.include?('q')
            condition_params = normalize_query_params(query_params)
          else
            condition_params = query_params
          end

          condition_params.reject.reject { |k,v| v.blank? }.each do |field, condition|
            case field
            when 'limit'
              scope = scope.limit(condition.to_i)
            when 'offset'
              scope = scope.offset(condition.to_i)
            when 'order'
              scope = scope.order(condition)
            when 'includes'
              scope = scope.includes(condition.map(&:to_sym))
            else
              condition_statement = ::Rao::Query::ConditionParser.new(scope, field, condition).condition_statement
              scope = scope.where(condition_statement)
            end
          end
          scope
        end

        def query_params
          default_query_params
        end

        def default_query_params
          request.query_parameters.except(*default_query_params_exceptions)
        end

        def default_query_params_exceptions
          %w(sort_by sort_direction utf8 commit page)
        end

        def normalize_query_params(params)
          params['q'].each_with_object({}) { |(k, v), m| m[normalize_key(k)] = v }
        end

        def normalize_key(key)
          splitted_key = key.split('_')
          predicate = splitted_key.last
          attribute = splitted_key[0..-2].join('_')
          "#{attribute}(#{predicate})"
        end
      end
    end
  end
end
