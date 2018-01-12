window.Bootsy = window.Bootsy || {};

var pageStylesheets = [];
$('link[rel="stylesheet"]').each(function () {
  pageStylesheets.push($(this).attr('href'));
});

window.Bootsy.options = {};

$.extend(true, window.Bootsy.options, $.fn.wysihtml5.defaultOptions, {
  parserRules: {
    classes: {
      "wysiwyg-float-left": 1,
      "wysiwyg-float-right": 1,
      "wysiwyg-float-inline": 1
    },
    tags: {
      "p":  {},
      "b":  {},
      "i":  {},
      "br": {},
      "ol": {},
      "ul": {},
      "li": {},
      "h1": {},
      "h2": {},
      "h3": {},
      "h4": {},
      "h5": {},
      "u":  {},
      "blockquote": {},
      "strong": { "rename_tag": "b" },
      "em": { "rename_tag": "i" },
      "span": 1,
      "div": 1,
      // to allow save and edit files with code tag hacks
      "code": 1,
      "pre": 1,
      "a": {
        "set_attributes": {
          "target": "_blank",
          "rel":    "nofollow"
        },
        "check_attributes": {
          "href":   "url" // important to avoid XSS
        }
      },
      "cite": {
        "check_attributes": {
          "title": "alt"
        }
      },
      "img": {
        "check_attributes": {
          "height": "numbers",
          "width": "numbers",
          "alt": "alt",
          "src": "src"
        },
        "add_class": {
          "align": "align_img"
        }
      },
      // this allows youtube embed codes
      "iframe": {
        "set_attributes": {
          "frameborder": "0",
          "allowfullscreen": "1"
        },
        "check_attributes": {
          "width": "numbers",
          "height": "numbers",
          "src": "href"
        }
      }
    }
  },
  color: false,
  html: true,
  stylesheets: pageStylesheets
});
