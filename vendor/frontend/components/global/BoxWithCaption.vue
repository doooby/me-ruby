<script setup>
import { defineProps } from 'vue'
defineProps({
  caption: String,
  icon: String,
})
</script>

<template>
<p class="mb-0 px-2 fs-3-div-4 d-flex align-items-center fe--font-body">
  <i v-if="icon" :class="`bi bi-${icon} me-2`"></i>
  <span>
    {{ caption }}:
  </span>
</p>
<div class="p-2 pb-0">
  <slot />
</div>
</template>
