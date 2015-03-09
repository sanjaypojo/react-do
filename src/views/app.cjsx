food = [
  "Code",
  "Code Review",
  "Eat a cookie"
]

ToDoFrame = React.createClass(
  toDoData: []
  getInitialState: () ->
    data: @toDoData
  componentDidMount: () ->
    @setState data: @toDoData
  addToDo: (item) ->
    @toDoData.push item
    @setState data: @toDoData
  render: () ->
    return (
      <div>
        <ToDoList data={@state.data}/>
        <NewToDo addToDo={@addToDo}/>
      </div>
    )
)

ToDoList = React.createClass(
  render: () ->
    allToDos = []
    for item in @props.data
      allToDos.push <ToDoItem data={item} />
    return(
      <ul>
        {allToDos}
      </ul>
    )
)

ToDoItem = React.createClass(
  render: () ->
    <li>{@props.data}</li>
)

NewToDo = React.createClass(
  onSubmitToDo: (e) ->
    e.preventDefault()
    console.log "Yo yo yo yo"
    newToDo = @refs.newToDo.getDOMNode().value.trim()
    if newToDo
      @props.addToDo(newToDo)
  render: () ->
    <form onSubmit={@onSubmitToDo}>
      <input type="text" ref="newToDo"></input>
      <button type="submit"> Add </button>
    </form>
)

React.render(
  <ToDoFrame data={food} />,
  document.getElementById "app-box"
)
