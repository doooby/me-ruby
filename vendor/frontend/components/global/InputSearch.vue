<script setup>
import { ref, useSlots } from 'vue'
import { useFloating } from '@floating-ui/vue'

const model = defineModel()
const slots = useSlots();

const searchText = ref('');
const selectedItem = ref(undefined);

const floatingReference = ref(null)
const floatingDialog = ref(null)
const { floatingStyles } = useFloating(floatingReference, floatingDialog)

function onSearch () {
 // show animation while processing
 // use searchText
}

function onDropdown () {
}

function onSearchKeydown (event) {
    // take care of ctrl + n / p for traversing the list 
    // also i guess up and down keys
}
</script>

<template>
<div class="d-flex flex-column">
  <div class="fe-control">
    <div class="fe-control--content">
      <input 
        v-if="!slots.selected"
        v-model="searchText"
        class="fe-control--content--input"
        type="text"
        @keydown="onSearchKeydown"
        />
      <div 
        v-else
        class="w-100"
        >
        <slot 
          name="selected"
          :item="selectedItem"
          />
      </div>
    </div>
    <div class="fe-control--buttons">
      <button class="d-flex btn"
        type="button"
        @click="onSearch"
        >
        <i class="bi bi-search"></i>
      </button>
      <button class="d-flex btn"
        type="button"
        @click="onDropdown"
        >
        <i class="bi bi-chevron-down"></i>
      </button>
    </div>
  </div>
  <div class="position-relative"
    :ref="floatingReference"
  >
    <div class="fe-control--dialog"
      :ref="floatingDialog"
      :style="floatingStyles"
    >
      ahoj
    </div>
  </div>
</div>
</template>
