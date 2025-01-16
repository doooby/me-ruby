<script setup>
import { defineProps } from 'vue'

defineProps({
  columns: Object,
  records: Array,
})
</script>

<template>
  <table class="table table-hover">
    <colgroup>
      <col
          v-for="(column, index) in columns.list"
          :key="column.id"
          :style="columns.cssStyles[index]"
        >
    </colgroup>
    <thead>
      <tr>
        <th
          v-for="column in columns.list"
          :key="column.id"
        >
          <div>
            {{ column.caption }}
          </div>
        </th>
      </tr>
    </thead>
    <tbody v-if="records?.length">

      <tr
        v-for="(record, record_index) in records"
        :key="record_index"
      >
        <td
          v-for="(column, column_index) in columns.list"
          :key="column_index"
        >
          <slot v-if="$slots[column.id]"
            :name="column.id"
            :record="record"
          />
          <div v-else>
            {{ record[column.id] }}
          </div>
        </td>
      </tr>
    </tbody>
    <slot />
  </table>
</template>

