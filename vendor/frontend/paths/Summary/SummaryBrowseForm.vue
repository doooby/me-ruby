<script setup>
import {} from 'vue'

</script>
<template>
<div class="d-flex align-items-center">
  <button class="btn fe--btn btn-secondary">
    <i class="bi bi-search"></i>
    <span class="me-2"></span>
    Select
  </button>
</div>
<ol>
  <li>
    <fe-printout
      caption="caption"
    >
    <input class="form-control fe--form-control"
      :placeholder="placeholder"
      type="text"
    />
    </fe-printout>
  </li>
</ol>
</template>
