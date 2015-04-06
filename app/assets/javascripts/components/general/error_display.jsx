/** @jsx React.DOM */

(function(global){
  global.JibJob = global.JibJob || {};

  global.JibJob.ErrorDisplay = React.createClass({
    propTypes: {
      errors: React.PropTypes.array.isRequired
    },

    render: function() {
      var items = this.props.errors.map(function(error, index) {
        var key = "error-" + index;
        return <ErrorItem data={error} key={key} />;
      });

      if (Object.getOwnPropertyNames(this.props.errors).length > 1) {
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