"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.SupportPage = React.createClass({
    brighten: function() {
      console.log("Brighten your day!");
    },

    darken: function() {
      console.log("Darkness prevails!");
    },

    componentDidMount: function() {

    },

    render: function() {
      return (
        <div className="container">
          <h3><span onMouseEnter={this.brighten}>Reactive</span> <span onMouseEnter={this.darken}>Support</span> Page</h3>
        </div>
      );
    }
  });
}(window));