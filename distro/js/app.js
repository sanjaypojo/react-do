(function() {
  var NewToDo, ToDoFrame, ToDoItem, ToDoList;

  ToDoFrame = React.createClass({
    toDoData: {},
    getInitialState: function() {
      var key, value, _ref;
      this.toDoData = JSON.parse(this.props.data);
      if (!this.toDoData) {
        this.toDoData = {};
      } else {
        _ref = this.toDoData;
        for (key in _ref) {
          value = _ref[key];
          if (!value.active) {
            delete this.toDoData[key];
          }
        }
      }
      return {
        data: this.toDoData
      };
    },
    componentDidMount: function() {
      return this.setState({
        data: this.toDoData
      });
    },
    addToDo: function(item) {
      var index, that;
      that = this;
      index = Math.random().toString(16).substr(2, 8);
      if (this.toDoData && this.toDoData[index]) {
        return this.addToDo(item);
      } else {
        this.toDoData[index] = item;
        localStorage.setItem("coreToDoData", JSON.stringify(that.toDoData));
        return that.setState({
          data: that.toDoData
        });
      }
    },
    removeToDo: function(guid) {
      var that;
      that = this;
      if (this.toDoData[guid]) {
        this.toDoData[guid].active = false;
        localStorage.setItem("coreToDoData", JSON.stringify(that.toDoData));
        return that.setState({
          data: that.toDoData
        });
      } else {
        return console.log(this.toDoData);
      }
    },
    render: function() {
      return React.createElement("div", null, React.createElement("h1", null, "React.Do"), React.createElement(ToDoList, {
        "data": this.state.data,
        "removeToDo": this.removeToDo
      }), React.createElement(NewToDo, {
        "addToDo": this.addToDo
      }));
    }
  });

  ToDoList = React.createClass({
    render: function() {
      var allToDos, guid, value, _ref;
      allToDos = [];
      _ref = this.props.data;
      for (guid in _ref) {
        value = _ref[guid];
        console.log(guid);
        if (value.active) {
          allToDos.push(React.createElement(ToDoItem, {
            "data": value,
            "guid": guid,
            "key": guid,
            "removeToDo": this.props.removeToDo
          }));
        }
      }
      return React.createElement("div", {
        "className": "container"
      }, allToDos);
    }
  });

  ToDoItem = React.createClass({
    onRemoveToDo: function(e) {
      e.preventDefault();
      return this.props.removeToDo(this.props.guid);
    },
    render: function() {
      return React.createElement("div", {
        "className": "to-do"
      }, this.props.data.text, React.createElement("span", {
        "className": "close",
        "onClick": this.onRemoveToDo
      }, "\u00d7"));
    }
  });

  NewToDo = React.createClass({
    getInitialState: function() {
      return {
        text: "",
        active: true
      };
    },
    onInputChange: function(e) {
      return this.setState({
        text: e.target.value,
        active: true
      });
    },
    onSubmitToDo: function(e) {
      var newToDo;
      console.log(e);
      e.preventDefault();
      newToDo = this.state;
      if (newToDo.text) {
        this.props.addToDo(newToDo);
        return this.setState({
          text: "",
          active: true
        });
      }
    },
    render: function() {
      return React.createElement("div", {
        "className": "form-container"
      }, React.createElement("form", {
        "onSubmit": this.onSubmitToDo
      }, React.createElement("input", {
        "type": "text",
        "ref": "newToDo",
        "onChange": this.onInputChange,
        "value": this.state.text
      }), React.createElement("button", {
        "type": "submit"
      }, " Add ")));
    }
  });

  React.render(React.createElement(ToDoFrame, {
    "data": localStorage.getItem("coreToDoData")
  }), document.getElementById("app-box"));

}).call(this);
