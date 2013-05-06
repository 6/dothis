window.app ?= {}

class app.TodoList extends Backbone.Collection
  model: app.Todo

  url: ->
    "/users/#{app.User.get('id')}/tasks"

  # Filter down the list of all todo items that are finished.
  completed: ->
    @filter (todo) -> todo.get('completed')

  # Filter down the list to only todo items that are still not finished.
  remaining: ->
    @without.apply(@, @completed())

  # We keep the Todos in sequential order, despite being saved by unordered
  # GUID in the database. This generates the next order number for new items.
  nextOrder: ->
    if !@length
      return 1
    return @last().get('order') + 1

  # Todos are sorted by their original insertion order.
  comparator: (todo) ->
    todo.get('order')
