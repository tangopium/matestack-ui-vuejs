module Matestack
  module Ui
    module VueJs
      module Components
        class Async < Matestack::Ui::VueJs::Vue
          vue_name 'matestack-ui-core-async'

          required :id
          optional :show_on, :hide_on, :rerender_on, :defer

          # register itself as an async component in the context
          def initialize(html_tag = nil, text = nil, options = {}, &block)
            super(html_tag, text, options, &block)
            Matestack::Ui::Core::Context.async_components = {} if Matestack::Ui::Core::Context.async_components.nil?
            Matestack::Ui::Core::Context.async_components[self.ctx.id] = self
          end

          def create_children(&block)
            self.response &block
          end

          def response
            if params[:component_key] && !is_not_requested?
              div async_attributes do
                yield
              end
            else
              vue_component do
                div class: 'matestack-async-component-container', 'v-bind:class': '{ "loading": vc.loading === true }' do
                  div class: 'matestack-async-component-wrapper', 'v-if': 'vc.asyncTemplate == null', 'v-bind:class': '{ "loading": vc.loading === true }' do
                    div async_attributes do
                      if params[:component_key]
                        # we need to yield if a request is looking for a async component, indicated through present params[:component_key]
                        # the requested component could be hidden within this deferred async!
                        yield
                      else
                        yield unless is_deferred?
                      end
                    end
                  end
                  div class: 'matestack-async-component-wrapper', 'v-if': 'vc.asyncTemplate != null', 'v-bind:class': '{ "loading": vc.loading === true }' do
                    Matestack::Ui::Core::Base.new('matestack-ui-core-runtime-render', ':template': 'vc.asyncTemplate', ':vc': 'vc')
                  end
                end
              end
            end
          end

          def async_attributes
            options.merge({
              id: ctx.id,
              class: 'matestack-async-component-root',
              'v-if': 'vc.showing'
            })
          end

          def vue_props
            {
              component_key: ctx.id,
              show_on: ctx.show_on,
              hide_on: ctx.hide_on,
              rerender_on: ctx.rerender_on,
              defer: ctx.defer,
              parent_class: isolated_parent ? isolated_parent.class.to_s : nil,
              public_context: isolated_parent&.public_context.to_h || params[:public_context]
            }
          end

          def is_deferred?
            ctx.defer
          end

          def is_not_requested?
            params[:component_key].present? && params[:component_key] != ctx.id
          end

          def isolated_parent
            Matestack::Ui::Core::Context.isolated_parent
          end

        end
      end
    end
  end
end
