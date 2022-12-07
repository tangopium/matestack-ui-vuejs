require 'rails_vue_js_spec_helper'
require_relative "../support/test_controller"
include VueJsSpecUtils

describe "Action Component", type: :feature, js: true do

  before :each do
    class ActionTestController < TestController
      def test
        render json: { }, status: 200
      end
    end

    allow_any_instance_of(ActionTestController).to receive(:expect_params)
  end

  describe "emit attribute" do

    it "if set, emits event(s) directly when action is submitted (not waiting for success or failure)" do
      Rails.application.routes.append do
        post '/action_test', to: 'action_test#test', as: 'action_emit'
      end
      Rails.application.reload_routes!

      class ExamplePage < Matestack::Ui::Page
        def response
          action action_config do
            button text: "Click me!"
          end
          toggle show_on: "action_submitted" do
            plain "action_submitted emitted"
          end
          toggle show_on: "foo" do
            plain "foo emitted"
          end
        end

        def action_config
          return {
            method: :post,
            path: action_emit_path,
            data: {
              foo: "bar"
            },
            emit: "action_submitted, foo"
          }
        end
      end

      visit "/example"
      expect_any_instance_of(ActionTestController).to receive(:expect_params)
        .with(hash_including(:foo => "bar"))
      click_button "Click me!"
      expect(page).to have_content("action_submitted emitted")
      expect(page).to have_content("foo emitted")
    end

  end

end
