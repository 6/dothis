window.app ?= {}

class app.Todo extends Backbone.Model
  defaults:
    title: ''
    completed: false

  url: ->
    path = "/users/#{app.User.get('id')}/tasks"
    path += "/#{@get('id')}"  if @get('id')
    path

  # Toggle the `completed` state of this todo item.
  toggle: ->
    @save(completed: !@get('completed'))
