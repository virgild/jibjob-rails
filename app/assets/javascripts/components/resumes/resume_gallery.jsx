/** @jsx React.DOM */

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeGallery = React.createClass({
    propTypes: {
      resumes: React.PropTypes.array.isRequired,
      createPage: React.PropTypes.string.isRequired,
      showCreateButton: React.PropTypes.bool.isRequired,
    },

    getDefaultProps: function() {
      return {
        resumes: []
      };
    },

    componentDidMount: function() {
    },

    render: function() {
      var resumes = this.props.resumes.map(function(resume, index) {
        var key = "resume-" + resume.id;
        if (resume.pdf_file_synced) {
          return <JibJob.ResumeListItem resume={resume} key={key} />;
        } else {
          return <JibJob.ResumeListPendingItem resume={resume} key={key} />;
        }
      });

      if (this.props.showCreateButton) {
        var createButton = <JibJob.ResumeListCreateItem createPage={this.props.createPage} />;
      }

      return (
        <div className="container">
          <div className="resume-list">
            <div className="row">
              {resumes}
              {createButton}
            </div>
          </div>
        </div>
      );
    }
  });
}(window));