ToDoFrame = React.createClass(
  toDoData: {}
  getInitialState: () ->
    @toDoData = JSON.parse @props.data
    if !@toDoData then @toDoData = {}
    data: @toDoData
  componentDidMount: () ->
    @setState data: @toDoData
  addToDo: (item) ->
    that = this
    index = Math.random().toString(16).substr(2,8)
    if @toDoData && @toDoData[index]
      @addToDo(item)
    else
      @toDoData[index] = item
      localStorage.setItem "coreToDoData", JSON.stringify(that.toDoData)
      that.setState data: that.toDoData
  removeToDo: (guid) ->
    that = this
    if @toDoData[guid]
      @toDoData[guid].active = false
      localStorage.setItem "coreToDoData", JSON.stringify(that.toDoData)
      that.setState data: that.toDoData
    else
      console.log @toDoData
  render: () ->
    return (
      <div>
        <h1>React.Do</h1>
        <ToDoList data={@state.data} removeToDo={@removeToDo}/>
        <NewToDo addToDo={@addToDo}/>
      </div>
    )
)

ToDoList = React.createClass(
  render: () ->
    allToDos = []
    for guid, value of @props.data
      console.log guid
      if value.active
        allToDos.push <ToDoItem data={value} guid={guid} removeToDo={@props.removeToDo}/>
    return(
      <div className="container">
        {allToDos}
      </div>
    )
)

ToDoItem = React.createClass(
  onRemoveToDo: (e) ->
    e.preventDefault()
    @props.removeToDo(@props.guid)
  render: () ->
    <div className="to-do">
      {@props.data.text}
      <span className="close" onClick={@onRemoveToDo}>&times;</span>
    </div>
)

NewToDo = React.createClass(
  getInitialState: () ->
    return {text: "", active: true}
  onInputChange: (e) ->
    @setState {text: e.target.value, active: true}
  onSubmitToDo: (e) ->
    console.log e
    e.preventDefault()
    newToDo = @state
    if newToDo.text
      @props.addToDo(newToDo)
      @setState {text: "", active: true}
  render: () ->
    <div className="form-container">
      <form onSubmit={@onSubmitToDo}>
        <input type="text" ref="newToDo" onChange={@onInputChange} value={@state.text} />
        <button type="submit"> Add </button>
      </form>
    </div>
)

React.render(
  <ToDoFrame data={localStorage.getItem "coreToDoData"} />,
  document.getElementById "app-box"
)
