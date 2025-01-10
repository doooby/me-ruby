<script setup>
import {ref} from 'vue'
import * as app from '%root/src/app'
import rdb from '%root/vendor/recordable'
import components from '%root/src/components'
const ui = components.toolkit

const tasks = ref([])

const aa = app.DataReader.useRead({
  payloadMapper: rdb.list(app.tasks.initializeTask),
})
aa.read((value) => {
  console.log('done', value)
})

// const dataReader = new app.DataReader({
//   payloadMapper: rdb.list(app.tasks.initializeTask),
// })
// const dataReaderState = ref(dataReader.state)
// dataReader.onChange = (newState) => {
//   dataReaderState.value = newState
// }
// dataReader.read().then(
//   () => tasks.value = dataReaderState.value.record
// )


</script>

<template>
  <ui.DataTable>
    <tbody>
      <tr v-for="task in tasks">
        <td>{{ task.id }}</td>
        <td>{{ task.task }}</td>
      </tr>
    </tbody>
  </ui.DataTable>
</template>
