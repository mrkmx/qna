User.create!([
  {email: 'user1@example.com', password: 'password', password_confirmation: 'password'},
  {email: 'user2@example.com', password: 'password', password_confirmation: 'password'},
])
Question.create!([
  {title: "My 1st question", body: "where i'am?", user_id: 1}
])
Answer.create!([
  {question_id: 1, body: "details: it's a room!", user_id: 1},
  {question_id: 1, body: "i don't know...", user_id: 2}
])
