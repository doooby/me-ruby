import { parseISO } from 'date-fns'

export function tryParse (value) {
  if (value instanceof Date) {
    return value
  } else if (typeof value === 'string') {
    return parseISO(value)
  }
}
