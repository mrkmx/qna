import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    this.perform('follow', { question_id: gon.params['id'] })
  },

  received(data) {
    if (!(gon.user_id === data.answer.user_id)) {
      const answerTemplate = require('templates/answer.hbs')({
        answer: data.answer,
        links: data.links,
        rating: data.rating
      })

      $('.answers').append(answerTemplate)
    }
  }
});
