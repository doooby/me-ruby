import rdb from '%root/vendor/recordable'

export function initializeTask (value) {
  return rdb.record((value) => ({
    id: rdb.dig(value, 'id', rdb.integer),
    task: rdb.dig(value, 'task', rdb.string),
  }))(value)
}
