window.app ?= {}

class app.AppView extends Backbone.View
  el: '#todoapp'

  events:
    'keypress #new-todo': 'createOnEnter'
    'click #clear-completed': 'clearCompleted'

  initialize: ->
    @footerTemplate = JST['tasks/footer']
    @$input = this.$('#new-todo')
    @$footer = this.$('#footer')
    @$main = this.$('#main')

    @listenTo(app.Todos, 'add', @addOne)
    @listenTo(app.Todos, 'reset', @addAll)
    @listenTo(app.Todos, 'all', @render)

    app.Todos.fetch()

  render: ->
    completed = app.Todos.completed().length

    if app.Todos.length
      @$main.show()
      @$footer.show()

      @$footer.html(@footerTemplate(completed: completed))
    else
      @$main.hide()
      @$footer.hide()

  addOne: (todo) ->
    view = new app.TodoView(model: todo)
    $('#todo-list').append(view.render().el)

  addAll: ->
    @$('#todo-list').html('')
    app.Todos.each(@addOne, @)

  newAttributes: ->
    {
      title: @$input.val().trim()
      order: app.Todos.nextOrder()
      completed: false
    }

  createOnEnter: (e) ->
    return  if e.which != ENTER_KEY || !@$input.val().trim()

    app.Todos.create(@newAttributes())
    @$input.val('')

  clearCompleted: ->
    _.invoke(app.Todos.completed(), 'destroy')
    false
