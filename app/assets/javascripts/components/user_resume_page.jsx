"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.UserResumePage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {

    },

    render: function() {
      var resume = this.props.resume;

      return (
        <div className="container">
          <div className="row">
            <div className="col-md-3">
              <div className="details">
                <h3>{resume.name} Details </h3>
                <div>
                  Created: {resume.created_at}
                </div>
                <div>
                  Updated: {resume.updated_at}
                </div>
                <div>
                  Published: {resume.is_published ? "Yes" : "No"}
                </div>
                <div>
                  Publish URL: {resume.slug}
                </div>
              </div>
            </div>
            <div className="col-md-9">
              <div className="actions">
                <div className="btn-group">
                  <a href={resume.edit_page} className="btn btn-default">Edit</a>
                  <a href={resume.delete_page} className="btn btn-danger">Delete</a>
                </div>
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