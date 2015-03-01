var React = require('react/addons');
var PublicationPanel = require('./publication_package_panel.jsx');
var Resume = require('./publication_resume.jsx');

module.exports = React.createClass({
  propTypes: {
    resume: React.PropTypes.object.isRequired,
  },

  componentDidMount: function() {
  },

  mouseEnter: function(e) {
    var panel = this.refs.panel;
    if (panel) {
      $(panel.getDOMNode()).removeClass('inactive');
    }
  },

  mouseLeave: function(e) {
    var panel = this.refs.panel;
    if (panel) {
      $(panel.getDOMNode()).addClass('inactive');
    }
  },

  render: function() {
    var resume = this.props.resume;

    return (
      <div className="page">
        <div className="container" onMouseEnter={this.mouseEnter} onMouseLeave={this.mouseLeave}>
          <PublicationPanel ref="panel" pdf_url={resume.pdf_file_url} plaintext_url={resume.plaintext_file_url} />
          <Resume data={resume.structure} />
          <Footer />
        </div>
      </div>
    );
  }
});

var Footer = React.createClass({
  render: function() {
    return (
      <div className="footer hidden-print">
        <div className="powered">
          Published by <a href="/">jibjob</a>
        </div>
      </div>
    );
  }
});