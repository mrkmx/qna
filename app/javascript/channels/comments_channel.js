import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    this.perform('follow', { question_id: gon.params['id'] })
  },

  received(data) {
    if (!(gon.user_id === data.comment.user_id)) {
      const commentTemplate = require('templates/comment.hbs')({ comment: data.comment })

      if (data.comment.commentable_type === 'Question') {
        $('.comments__question .comments-list').append(commentTemplate)
      } else {
        $('.comments__answer .comments-list').append(commentTemplate)
      }
    }
  }
});