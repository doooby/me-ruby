<script setup>
import * as app from '%root/src/app'
import rdb from '%root/vendor/recordable'
import components from '%root/components'
import SummaryBrowseForm from '%root/paths/Summary/SummaryBrowseForm.vue'
import SummaryTable from '%root/paths/Summary/SummaryTable.vue'
const ui = components.toolkit

const { stateRef: previousDataState, reader: dataReader } = app.DataReader.useCached(
  new app.DataReader({
    resourcePath: 'summary.json',
    payloadMapper: rdb.record((value) => ({
      list: rdb.property(value, 'list', rdb.list(app.tasks.initializeTask)),
    })),
  })
)
dataReader.read()
</script>

<template>
  <div class="my-5">
    <section class="font-monospace">
      <SummaryBrowseForm
      />
    </section>
    <section class="font-monospace">
      <SummaryTable
        :records="previousDataState.record?.list"
      />
    </section>
  </div>
</template>
