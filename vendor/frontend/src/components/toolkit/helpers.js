import { reactive } from 'vue'


/**
 * @module MeToolkit
 *
 * @typedef {Object} MeToolkit.DataTableColumn
 * @property {string} id
 * @property {string} caption
 *
 * @typedef {Object} MeToolkit.DataTableContext
 * @property {any} payloadMapper
 * @property {Object} columns
 * @property {Set<MeToolkit.DataTableColumn>} columns.list
 * @property {Map.<string,MeToolkit.DataTableColumn>} columns.index
 * @property {Array<number>} columns.sizes
 * @property {Array<string>} columns.cssStyles
 * @property {Array<Object>} records
 */

/**
 * @param {any} context
 * @returns {MeToolkit.DataTableContext}
 */
export function castDataTableContext (context) {
  return context
}

/**
 * @param {Array<MeToolkit.DataTableColumn>} initialColumns
 * @param {Array<Object>} records
 * @returns {MeToolkit.DataTableContext}
 */
export function useDataTable (initialColumns, records) {
  initialColumns.forEach(item => Object.freeze(item))

  const columnsList = new Set(initialColumns)
  const sizes = new Array(initialColumns.length)
  const columns = reactive({
    list: columnsList,
    index: initialColumns.reduce(
      (map, column) => {
        map.set(column.id, column)
        return map
      },
      new Map(),
    ),
    sizes,
    cssStyles: Array.from(sizes, getColumnsSizeCssStyle),
  })

  const context = reactive({
    columns,
    records,
  })
  return context
}

/**
 * @param {number} size
 * @returns {string}
 */
function getColumnsSizeCssStyle (size) {
  if (isNaN(size)) size = 150
  return `width: ${size}px;`
}
