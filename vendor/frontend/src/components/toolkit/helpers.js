import { reactive } from 'vue'

/**
 * @module MeToolkit
 *
 * @typedef {Object} MeToolkit.DataTableColumn
 * @property {string} id
 * @property {string} caption
 *
 * @typedef {Object} MeToolkit.DataTableColumns
 * @property {Set<MeToolkit.DataTableColumn>} list
 * @property {Map<string,MeToolkit.DataTableColumn>} index
 * @property {Array<number>} sizes
 * @property {Array<string>} cssStyles
 */

/**
 * @param {Array<MeToolkit.DataTableColumn>} columns
 * @returns {MeToolkit.DataTableColumns}
 */
export function useDataTableColumns (...columns) {
  const list = new Set(columns)
  const index = columns.reduce(
    (map, column) => {
      map.set(column.id, column)
      return map
    },
    new Map(),
  )
  const sizes = new Array(columns.length)
  return reactive({
    list,
    index,
    sizes,
    cssStyles: Array.from(sizes, getColumnsSizeCssStyle),
    setColumnSize (index, size) {
      this.sizes[index] = size
      this.cssStyles[index] = getColumnsSizeCssStyle(size)
    }
  })
}

/**
 * @param {number} size
 * @returns {string}
 */
function getColumnsSizeCssStyle (size) {
  if (isNaN(size)) size = 150
  return `width: ${size}px;`
}
