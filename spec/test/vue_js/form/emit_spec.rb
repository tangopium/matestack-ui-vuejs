require 'rails_vue_js_spec_helper'
require_relative "../support/test_controller"
require_relative "support/form_test_controller"
require_relative "support/model_form_test_controller"
include VueJsSpecUtils

describe "Form Component", type: :feature, js: true do

  before :all do
    class EmitFormTestController < FormTestController
      def success_submit
        render json: { message: "server says: form submitted successfully" }, status: 200
      end
    end

    Rails.application.routes.prepend do
      post '/emit_success_form_test', to: 'emit_form_test#success_submit', as: 'form_emit_success_submit'
    end
    Rails.application.reload_routes!
  end

  before :each do
    allow_any_instance_of(EmitFormTestController).to receive(:expect_params)
  end

  describe "emit attribute" do

    it "if set, emits event directly when form is submitted (not waiting for success or failure)" do
      class ExamplePage < Matestack::Ui::Page
        def response
          matestack_form form_config do
            form_input key: :foo, type: :text, id: "my-test-input"
            button 'Submit me!'
          end
          toggle show_on: "form_submitted" do
            plain "form submitted!"
          end
          toggle show_on: "some_other_event" do
            plain "some_other_event: form submitted!"
          end
        end

        def form_config
          return {
            for: :my_object,
            method: :post,
            path: form_emit_success_submit_path,
            emit: "form_submitted, some_other_event"
          }
        end
      end

      visit '/example'
      fill_in "my-test-input", with: "bar"
      expect_any_instance_of(EmitFormTestController).to receive(:expect_params)
        .with(hash_including(my_object: { foo: "bar" }))

      click_button "Submit me!"
      expect(page).to have_content("form submitted!")
      expect(page).to have_content("some_other_event: form submitted!")
    end
  end

end
