$(document).on('turbolinks:load', function(){
  $('.rating').on('ajax:success', function(event) {
    const votable = event.detail[0]
    const votable_id = `#${votable["votable_type"]}-${votable["votable_id"]}`
    const counter = $(votable_id).find('.rating-counter')
    const vote_links = $(votable_id).find('.vote-links')
    const revote_link = $(votable_id).find('.revote-link')
    
    counter.html(votable["rating"])

    if (vote_links.hasClass('hidden')) {
      vote_links.show()
      revote_link.hide()
    } else {
      vote_links.hide()
      revote_link.show()
    }
  })
})
