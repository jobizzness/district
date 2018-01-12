window.Bootsy = window.Bootsy || {};

window.Bootsy.imageTemplate = function(locale, options) {
  var size = (options && options.size) ? ' btn-' + options.size : '';

  return  '<li>' +
    '<a class="btn btn-primary ' + size + '" data-wysihtml5-command="customCommand" title="' + locale.image.insert + '" tabindex="-1">' +
      '<span class="fa fa-picture-o"></span>' +
    '</a>' +
  '</li>';
};
