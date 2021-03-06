module Rao
  module Component
    # Basic usage:
    #
    #     # app/views/pictures/index.html.haml
    #     = collection_table(collection: @pictures) do |table|
    #       = table.acts_as_published_actions
    #
    # You will have to add a publishing route to your resource:
    #
    #     # config/routes.rb:
    #     Rails.application.routes do
    #       resources :picture do
    #         post :toggle_published, on: :member
    #       end
    #       # ...
    #     end
    #
    # Additionally you will need a controller action to handle the reponsitioning.
    # Include Rao::ResourcesController::ActsAsPublishedConcern from rao-resource_controller
    # if you don't want to implement it yourself:
    #
    #     # app/controllers/pictures_controller.rb
    #     class PicturesController < ApplicationController
    #       include Rao::ResourcesController::ActsAsPublishedConcern
    #       # ...
    #     end
    #
    module CollectionTable::ActsAsPublishedConcern
      extend ActiveSupport::Concern

      def acts_as_published_actions(options = {}, &block)
        options.reverse_merge!(render_as: :acts_as_published, title: t('.column_titles.acts_as_published'))
        column(:acts_as_published_actions, options, &block)
      end
    end
  end
end