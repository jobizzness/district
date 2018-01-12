class ChatApp
  constructor: ->
    do @bindEvents

  bindEvents: ->
    $('.chat').each @updateChatBox
    $('.chat-form').on 'ajax:success', @success
    $('.chat .messages').bind 'heightChange', @scrollChatBox

  scrollChatBox: ->
    @scrollTop = @scrollHeight

  success: (e, message) =>
    $form = $ e.target
    $box  = $form
              .closest '.chat'
              .find '.messages'

    @clearField $form
    @addToChatBox $box, message

  addToChatBox: ($box, message) =>
    $box
      .append message
      .trigger 'heightChange'

  clearField: ($form) =>
    $form
      .find 'input[name=body]'
      .val ''

  updateChatBox: (i, el) =>
    bidId = $(el).data 'bidId'
    $box  = $(el).find '.messages'
    @update $box, bidId

  update: ($box, bidId, count=0) =>
    $.post '/ajax/chatMessages', bid_id: bidId, (messages) =>
      $box.html messages
      $box.trigger 'heightChange' if count < $(messages).length
      setTimeout =>
        @update $box, bidId, $(messages).length
      , 750

$ -> new ChatApp
