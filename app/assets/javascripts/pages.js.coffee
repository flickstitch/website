# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.votes > a > img').click ->
    toggle_vote_image($(this))
    update_vote_count($(this))

  # update href on vote link; doesn't matter if success or failure so use "complete" status
  $('.votes > a').bind 'ajax:complete', ->
    original_href = $(this).attr('href')
    if original_href.indexOf('_up') <= -1
      new_href = original_href.replace /_down/, '_up'
    else
      new_href = original_href.replace /_up/, '_down'

    $(this).attr('href', new_href)

  # toggle thumbs up image between grey and blue
  # the toggle happens immediately to make the site 
  # seem fast and responsive
  toggle_vote_image = (vote_image) ->
    toggle_image = ''
    original_image = vote_image.attr('src')
    index = original_image.indexOf 'current'

    if index <= -1
      toggle_image = original_image.replace /.png/, '_current.png'
    else
      toggle_image = original_image.replace /_current.png/, '.png'

    vote_image.attr('src', toggle_image)

  update_vote_count = (image_tag) ->
    vote_count_div = image_tag.closest('.votes').children('.vote-count')
    vote_count = parseInt(vote_count_div.text())

    if image_tag.attr('src').indexOf('_current') <= -1
      vote_count = vote_count - 1
    else
      vote_count = vote_count + 1

    vote_count_div.html(vote_count)

  # show alert to users that try to vote while not logged in
  $('.cannot-vote').click ->
    alert('You must sign in or register to vote!')
