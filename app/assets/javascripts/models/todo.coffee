window.app ?= {}

class app.Todo extends Backbone.Model
  defaults:
    title: ''
    completed: false

  # Toggle the `completed` state of this todo item.
  toggle: ->
    @save(completed: !@get('completed'))
