/** @jsx React.DOM */

(function(global){
  global.JibJob = global.JibJob || {};

  global.JibJob.ErrorDisplay = React.createClass({
    propTypes: {
      model: React.PropTypes.object.isRequired
    },

    render: function() {
      var model = this.props.model;

      var items = model.errors.map(function(error, index) {
        var key = "error-" + index;
        return <ErrorItem data={error} key={key} />;
      });

      if (Object.getOwnPropertyNames(model.errors).length > 1) {
        return (
          <div className="error-display">
            <h4>There are errors in the form</h4>
            <ul>
              {items}
            </ul>
          </div>
        );
      } else {
        return null;
      }
    }
  });

  var ErrorItem = React.createClass({
    propTypes: {
      data: React.PropTypes.any.isRequired
    },

    render: function() {
      var errorMessage = this.props.data;

      return (
        <li>{errorMessage}</li>
      );
    }
  });
}(window));