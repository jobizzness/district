selectAllItem = (table) ->
  $theadCheckboxes = $(table).find 'thead :checkbox'
  $tbodyCheckboxes = $(table).find 'tbody :checkbox'

  $theadCheckboxes.on 'change', ->
    $tbodyCheckboxes.prop 'checked', this.checked

  $tbodyCheckboxes.on 'change', ->
    isCheckedAll = !$tbodyCheckboxes.not(':checked').length
    $theadCheckboxes.prop 'checked', isCheckedAll

$tables = $ '[data-table]'

$tables.each (index, table) ->
  switch table.dataset.table
    when 'checkbox'
      selectAllItem table
