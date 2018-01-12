class ProjectGallery
  GALLERY = '[project-gallery]'
  BIG_IMAGE = '[big-image]'
  MODAL_GALLERY = '.modal-gallery'

  constructor: ->
    $ GALLERY
      .on 'click', '.thumbs i', @toggleThumb
      .on 'click', BIG_IMAGE, @showModal

    $ document
      .on 'click', "#{MODAL_GALLERY} .close", @closeModal
      .on 'click', "#{MODAL_GALLERY} .gallery-button", @slideModal
      .on 'click', "#{MODAL_GALLERY} .thumbs img", @chooseImgModal

  toggleThumb: (e) =>
    @gallery = $(e.target).closest GALLERY

    @gallery
      .find '.thumbs i'
      .removeClass 'active'

    @setBigImage(
      $(e.target)
        .addClass 'active'
        .attr 'style'
    ,
      $(e.target)
        .attr 'price'
    )

    return

  setBigImage: (style, price) =>
    @gallery
      .find BIG_IMAGE
      .attr
        'style': style
        'price': price

  showModal: (e) =>
    @gallery = $(e.target).closest GALLERY

    url = @gallery
      .find BIG_IMAGE
      .css 'background-image'

    bigImageUrl = url.match(/\"([^)]+)\"/) and url.match(/\"([^)]+)\"/)[1] or url.match(/\(([^)]+)\)/)[1]
    $thumbs = @gallery.find '.thumbs i'
    bigPrice = $(e.target).attr 'price'

    template = @templateModal bigImageUrl.replace('medium', 'original'), bigPrice, $thumbs
    $(template).appendTo('body')

  closeModal: (e) =>
    e.preventDefault()
    $(MODAL_GALLERY).remove()    

  slideModal: (e) =>
    e.preventDefault()

    $btn = $ e.target
    $modalGallery = $ MODAL_GALLERY
    $currentThumb = $modalGallery.find '.thumbs img.active'
    $thumbs = $modalGallery.find '.thumbs img'

    if $btn.hasClass 'next'
      $next = $currentThumb.next()
      @setModalBigImage if $next.length > 0 then $next else $thumbs.first()

    else if $btn.hasClass 'prev'
      $prev = $currentThumb.prev()
      @setModalBigImage if $prev.length > 0 then $prev else $thumbs.last()

  chooseImgModal: (e) =>
    @setModalBigImage $(e.target)

  setModalBigImage: ($thumb) =>
    $modalGallery = $ MODAL_GALLERY

    $modalGallery
      .find '.thumbs img'
      .removeClass 'active'

    url = $thumb
            .addClass 'active'
            .attr 'src'
            .replace 'medium', 'original'

    $modalGallery
      .find '.big-image'
      .attr 'price', $thumb.attr('price')
      .find 'img'
      .attr 'src', url

  templateModal: (bigImageUrl, bigPrice, $thumbs) =>
    thumbs = ''

    $thumbs.each (i, el) ->
      url = $(el).css 'background-image'
      url = url.match(/\"([^)]+)\"/) and url.match(/\"([^)]+)\"/)[1] or url.match(/\(([^)]+)\)/)[1]
      price = $(el).attr('price') and "price='#{$(el).attr('price')}'" or ''
      active = $(el).hasClass('active') and "class='active'" or ''
      thumbs += "<img src='#{url}' alt='' #{price} #{active}>"

    """
    <div class="modal-gallery">
      <div class="big-image" price="#{bigPrice or ''}">
        <a href="#" class="close"></a>
        <a href="#" class="gallery-button next"></a>
        <a href="#" class="gallery-button prev"></a>
        <img src="#{bigImageUrl}" alt="">
      </div>

      <div class="thumbs">#{thumbs}</div>    
    </div>
    """

$ -> new ProjectGallery
