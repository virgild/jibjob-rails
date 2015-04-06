/** @jsx React.DOM */

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeListCreateItem = React.createClass({
    propTypes: {
      createPage: React.PropTypes.string.isRequired
    },

    render: function() {
      return (
        <div className="col-md-3 col-sm-4 col-xs-12">
          <div className="resume-list-item placeholder">
            <a id="create-button" href={this.props.createPage}>
              <div className="thumb">
                <span className="glyphicon glyphicon-plus icon"/>
                <br/>
                Create
              </div>
            </a>
          </div>
        </div>
      );
    }
  });
}(window));