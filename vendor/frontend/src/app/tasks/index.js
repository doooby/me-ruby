import rdb from '%root/vendor/recordable'

export function initializeTask (value) {
  return rdb.record((value) => ({
    id: rdb.dig(value, 'id', rdb.integer),
    task: rdb.dig(value, 'task', rdb.optional(rdb.string)),
    start_at: rdb.dig(value, 'start_at', rdb.optional(rdb.string)),
    end_at: rdb.dig(value, 'end_at', rdb.optional(rdb.string)),
    message: rdb.dig(value, 'message', rdb.optional(rdb.string)),
  }))(value)
}
