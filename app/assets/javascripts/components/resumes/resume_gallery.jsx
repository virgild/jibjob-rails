/** @jsx React.DOM */
(function(global) {
  "use strict";
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeGallery = React.createClass({
    propTypes: {
      resumes: React.PropTypes.array.isRequired,
      createPage: React.PropTypes.string.isRequired,
      showCreateButton: React.PropTypes.bool.isRequired,
      pdfStatusURL: React.PropTypes.string.isRequired
    },

    getDefaultProps: function() {
      return {
        resumes: []
      };
    },

    getInitialState: function() {
      return {
        isLoadingPDFStatus: false
      };
    },

    componentDidMount: function() {
      if (this.hasPendingResumes()) {
        this.startUpdatingPDFStatus();
      }
    },

    componentWillUnmount: function() {
      window.clearTimeout(this.state.pdfStatusTimer);
    },

    pendingResumes: function() {
      var resumes = this.props.resumes.filter(function(resume) {
        if (resume.pdf_file_synced) {
          return false
        } else {
          return true;
        }
      });

      return resumes;
    },

    hasPendingResumes: function() {
      return this.pendingResumes().length > 0;
    },

    startUpdatingPDFStatus: function() {
      var self = this;
      var timer = global.setTimeout(function() {
        self.loadPDFStatus();
      }, 5000);
      self.setState({ pdfStatusTimer: timer });
    },

    loadPDFStatus: function(callback) {
      var self = this;
      var ids = this.pendingResumes().map(function(resume) { return resume.id; });

      self.setState({ isLoadingPDFStatus: true });

      $.ajax({
        url: self.props.pdfStatusURL,
        data: { ids: ids },
        method: 'GET'
      }).done(function(data) {
        self.updatePDFStatus(data);
      }).fail(function(xhr, status) {

      }).always(function(xhr) {
        self.setState({ isLoadingPDFStatus: false, pdfStatusTimer: null });
      });
    },

    updatePDFStatus: function(statusData) {
      var self = this;
      statusData.forEach(function(data) {
        self.applyPDFStatusChanges(data);
        self.forceUpdate();
      });
    },

    applyPDFStatusChanges: function(data) {
      this.props.resumes.forEach(function(resume) {
        if (resume.id == data.id) {
          resume.pdf_file_synced = data.pdf_file_synced;
          resume.thumbnail = data.thumbnail;
        }
      });
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