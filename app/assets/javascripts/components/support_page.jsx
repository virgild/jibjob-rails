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

    render: function() {
      return (
        <div className="container">
          <h1><span onMouseEnter={this.brighten}>Reactive</span> <span onMouseEnter={this.darken}>Support</span> Page</h1>
        </div>
      );
    }
  });
}(window));