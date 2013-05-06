window.app ?= {}

class app.User extends Backbone.Model
  url: ->
    path = "/users"
    path += "/#{@get('id')}"  if @get('id')
    path
