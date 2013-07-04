validatePresenceOf = (value) ->
  value and value.length
mongoose = require("mongoose")
crypto = require("crypto")
module.exports = (app) ->
  UserSchema = new mongoose.Schema(
    username:
      type: String
      required: true
      unique: true

    hashed_password:
      type: String
      required: true

    salt:
      type: String
      required: true
  )
  UserSchema.virtual("password").set((password) ->
    @_password = password
    @salt = @makeSalt()
    @hashed_password = @encryptPassword(password)
  ).get ->
    @_password

  UserSchema.method "authenticate", (plainText) ->
    console.log "authenticate called:"
    console.log "plain text = " + plainText
    console.log "hashed = " + @encryptPassword(plainText)
    console.log "db password= " + @hashed_password
    @encryptPassword(plainText) is @hashed_password

  UserSchema.method "makeSalt", ->
    Math.round((new Date().valueOf() * Math.random())) + ""

  UserSchema.method "encryptPassword", (password) ->
    crypto.createHmac("sha1", @salt).update(password).digest "hex"

  UserSchema.method "generateToken", ->
    crypto.createHash("md5").update(@username + Date().toString()).digest "hex"

  UserSchema.pre "save", (next) ->
    @token = @generateToken()
    unless validatePresenceOf(@password or @hashed_password)
      next new Error("Invalid password")
    else
      next()

  mongoose.model "User", UserSchema
