class @TasksCompletedByDayChart extends Backbone.View
  initialize: (attributes = {}) =>
    {@data} = attributes
    @transformedData = []
    _.map @data, (day, i) =>
      @transformedData.push({x: i, y: day.count})

  render: =>
    graph = new Rickshaw.Graph
      element: @el
      width: 960
      height: 300
      renderer: 'bar'
      series: [{
        color: 'steelblue'
        data: @transformedData
      }]
    graph.render()
