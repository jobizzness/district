$.validator.addMethod 'filesize', (value, element) ->
  this.optional(element) || 3 * 1024 > element.files[0].size / 1024 && value 
, 'The file is too large.'
