(function(global){
  global.JibJob = global.JibJob || {};

  global.JibJob.PublicationPage = React.createClass({
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
            <JibJob.PublicationPackagePanel ref="panel" pdf_url={resume.pdf_file_url} plaintext_url={resume.plaintext_file_url} />
            <JibJob.PublicationResume data={resume.structure} />
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
}(window));
