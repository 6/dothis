window.app ?= {}

class app.TodoView extends Backbone.View
  tagName:  'li'

  events:
    'click .toggle': 'toggleCompleted',
    'dblclick label': 'edit',
    'click .destroy': 'clear',
    'keypress .edit': 'updateOnEnter',
    'blur .edit': 'close'

  initialize: ->
    @template = _.template($('#item-template').html())
    @listenTo(@model, 'change', @render)
    @listenTo(@model, 'destroy', @remove)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$el.toggleClass('completed', @model.get('completed'))
    @$input = @$('.edit')
    @

  toggleCompleted: ->
    @model.toggle()

  # Switch this view into `"editing"` mode, displaying the input field.
  edit: ->
    @$el.addClass('editing')
    @$input.focus()

  # Close the `"editing"` mode, saving changes to the todo.
  close: ->
    value = @$input.val().trim()
    if value
      @model.save(title: value)
    else
      @clear()
    @$el.removeClass('editing')

  # If you hit `enter`, we're through editing the item.
  updateOnEnter: (e) ->
    @close()  if e.which == ENTER_KEY

  # Remove the item, destroy the model from *localStorage* and delete its view.
  clear: ->
    @model.destroy()
