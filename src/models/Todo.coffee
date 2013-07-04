mongoose = require("mongoose")
module.exports = (app) ->
  TodoSchema = new mongoose.Schema(
    text: #text of the todo
      type: String

    complete: #whether the todo is complete or not
      type: Boolean

    userId: #the user this todo belongs to
      type: mongoose.Schema.Types.ObjectId
  )
  mongoose.model "Todo", TodoSchema
