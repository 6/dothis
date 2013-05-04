window.app ?= {}

class Workspace extends Backbone.Router
  routes:
    '*filter': 'setFilter'

  setFilter: (param) ->
    # Set the current filter to be used
    app.TodoFilter = param || ''

    # Trigger a collection filter event, causing hiding/unhiding
    # of Todo view items
    app.Todos.trigger('filter')

app.TodoRouter = new Workspace()
Backbone.history.start()
