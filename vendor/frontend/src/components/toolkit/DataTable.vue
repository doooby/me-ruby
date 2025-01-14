<script setup>
import { defineProps } from 'vue'
import components from '%root/src/components'

const props = defineProps({
  context: Object,
})

const context = components.toolkit.helpers.castDataTableContext(props.context)
</script>

<template>
  <table class="table table-hover">
    <colgroup>
      <col
          v-for="(column, index) in context.columns.list"
          :key="column.id"
          :style="context.columns.cssStyles[index]"
        >
    </colgroup>
    <thead>
      <tr>
        <th
          v-for="column in context.columns.list"
          :key="column.id"
        >
          <div>
            {{ column.caption }}
          </div>
        </th>
      </tr>
    </thead>
    <tbody v-if="context.records?.length">

      <tr
        v-for="(record, record_index) in context.records"
        :key="record_index"
      >
        <td
          v-for="(column, column_index) in context.columns.list"
          :key="column_index"
        >
          <slot v-if="$slots[column.id]"
            :name="column.id"
            :record="record"
            :context="context"
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

