"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.UserResumePage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {
      global.JibJob.CurrentPage = this;
    },

    render: function() {
      var resume = this.props.resume;
      var origin = window.location.origin;
      var pub_url = origin + resume.publish_url;

      var accessCode = (function(access_code) {
        if (access_code) {
          return (
            <div>
              <b>Access code:</b> {resume.access_code}
            </div>
          );
        }
      }(resume.access_code));

      return (
        <div className="container">
          <div className="row">
            <div className="col-md-3">
              <div className="details">
                <h3>{resume.name} Details </h3>
                <div>
                  <b>Created:</b> {resume.created_at}
                </div>
                <div>
                  <b>Updated:</b> {resume.updated_at}
                </div>
                <div>
                  <b>Published:</b> {resume.is_published ? "Yes" : "No"}
                </div>
                <div>
                  <b>Publish URL:</b> <a href={pub_url}>{pub_url}</a>
                </div>
                {accessCode}
              </div>
            </div>
            <div className="col-md-9">
              <div className="actions">
                <a href={resume.edit_page} className="btn btn-default">Edit</a>
                <a href={resume.stats_page} className="btn btn-primary stats-button">Stats</a>
                <a href={resume.delete_page} className="btn btn-danger delete-button">Delete</a>
              </div>
            </div>
            <div className="col-md-9">
              <div className="preview">
                <h3>Preview</h3>
                <JibJob.PublicationPanel pdf_url={resume.user_pdf_file} plaintext_url={resume.user_plaintext_file} />
                <JibJob.Resume data={resume.structure} />
              </div>
            </div>
          </div>
        </div>
      );
    }
  });
}(window));