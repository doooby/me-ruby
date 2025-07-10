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
    <box-with-caption
      caption="Search"
      icon="search"
    >
    <div class="fe-control">
      <div class="fe-control--content">
        <input
          type="text"
          />
      </div>
    </div>
    </box-with-caption>
  </li>
  <li>
    <box-with-caption
      caption="Task"
      icon="list-task"
    >
      <input-search />
    </box-with-caption>
  </li>
  <li>
    <box-with-caption
      caption="Start at"
      icon="clock-history"
    >
      
    </box-with-caption>
  </li>
  <li>
    <box-with-caption
      caption="End at"
      icon="clock-history"
    >
     <input class="form-control fe--form-control"
      type="datetime-local"
     />
    </box-with-caption>
  </li>
</ol>
</template>
