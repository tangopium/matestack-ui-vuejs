import axios from 'axios'
import eventHub from './event_hub'
const matestackEventHub = eventHub // for compatibility with 1.x

import componentMixin from './components/mixin'
import componentHelpers from './components/helpers'

import app from './components/app'

import pageSwitch from './components/page_switch'

import runtimeRender from './components/runtime_render'

import collectionContent from './components/collection/content'
import collectionFilter from './components/collection/filter'
import collectionOrder from './components/collection/order'

import toggle from './components/toggle'
import onclick from './components/onclick'
import transition from './components/transition'
import async from './components/async'
import action from './components/action'
import cable from './components/cable'
import draggable from './components/draggable'
import dropZone from './components/drop_zone'
import isolate from './components/isolated'
import form from './components/form/form'
import nestedForm from './components/form/nested_form'
import fieldsForAddItem from './components/form/fields_for_add_item'
import formCheckbox from './components/form/checkbox'
import formInput from './components/form/input'
import formRadio from './components/form/radio'
import formSelect from './components/form/select'
import formTextarea from './components/form/textarea'

import formInputMixin from './components/form/input_mixin'
import formSelectMixin from './components/form/select_mixin'
import formRadioMixin from './components/form/radio_mixin'
import formCheckboxMixin from './components/form/checkbox_mixin'
import formTextareaMixin from './components/form/textarea_mixin'

const registerComponents = function(appInstance){
  appInstance.config.compilerOptions.whitespace = "preserve"
  appInstance.config.compilerOptions.isCustomElement = tag => tag === 'matestack-component-template'
  appInstance.config.unwrapInjectedRef = true

  appInstance.component('matestack-ui-core-runtime-render', runtimeRender)

  appInstance.component('matestack-ui-core-app', app)
  appInstance.component('matestack-ui-core-page-switch', pageSwitch)
  appInstance.component('matestack-ui-core-collection-content', collectionContent)
  appInstance.component('matestack-ui-core-collection-filter', collectionFilter)
  appInstance.component('matestack-ui-core-collection-order', collectionOrder)
  appInstance.component('matestack-ui-core-draggable', draggable)
  appInstance.component('matestack-ui-core-drop-zone', dropZone)
  appInstance.component('matestack-ui-core-toggle', toggle)
  appInstance.component('matestack-ui-core-onclick', onclick)
  appInstance.component('matestack-ui-core-transition', transition)
  appInstance.component('matestack-ui-core-async', async)
  appInstance.component('matestack-ui-core-action', action)
  appInstance.component('matestack-ui-core-cable', cable)
  appInstance.component('matestack-ui-core-isolate', isolate)
  appInstance.component('matestack-ui-core-form', form)
  appInstance.component('matestack-ui-core-form-checkbox', formCheckbox)
  appInstance.component('matestack-ui-core-form-input', formInput)
  appInstance.component('matestack-ui-core-form-radio', formRadio)
  appInstance.component('matestack-ui-core-form-select', formSelect)
  appInstance.component('matestack-ui-core-form-textarea', formTextarea)
  appInstance.component('matestack-ui-core-form-nested-form', nestedForm)
  appInstance.component('matestack-ui-core-form-fields-for-add-item', fieldsForAddItem)

  return appInstance
}

const mount = function(appInstance, elementId='#matestack-ui'){
  if (window.matestackAppMounted != true){
    window.matestackAppMounted = true
    registerComponents(appInstance)

    appInstance.mount(elementId)
  }

  return appInstance
}

const MatestackUiVueJs = {
  axios,
  eventHub,
  matestackEventHub, // for compatibility with 1.x
  componentMixin,
  componentHelpers,
  formInputMixin,
  formSelectMixin,
  formCheckboxMixin,
  formTextareaMixin,
  formRadioMixin,
  registerComponents,
  mount
}

export default MatestackUiVueJs
