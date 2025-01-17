<script setup>
import { defineProps } from 'vue'
defineProps({
  caption: String,
  placeholder: String,
})
</script>

<template>
<p class="mb-0 px-2 fs-3-div-4 d-flex align-items-center fe--font-body">
  <i class="bi bi-search"></i>
  <span class="me-2"></span>
  {{ caption }}:
</p>
<div class="p-2 pb-0">
  <slot />
</div>
</template>
