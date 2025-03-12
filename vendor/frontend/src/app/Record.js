import {ref} from 'vue'
import rdb from '%root/vendor/recordable'
import * as app from '%root/src/app'

export default class Record extends rdb.Record {
  stateRef = null

  constructor (options) {
    options.url = new URL(`fe-api-v1/${options.path}`, app.env.serverOrigin)
    super(options)
    this.stateRef = ref(Object.freeze(this.state))
    this.onChange = (newState) => {
      this.stateRef.value = Object.freeze(newState)
    }
  }

  static useCached (record) {
    const stateRef = ref(record.stateRef.value)
    const fetch = record.fetch
    record.fetch = async () => {
      await fetch.call(record)
      stateRef.value = record.state
    }
    return { stateRef, record }
  }
}
