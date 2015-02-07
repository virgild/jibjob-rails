"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeList = React.createClass({
    propTypes: {
      resumes: React.PropTypes.array.isRequired,
      createPage: React.PropTypes.string,
    },

    getDefaultProps: function() {
      return {
        resumes: [],
      };
    },

    componentDidMount: function() {
      global.JibJob.CurrentPage = this;
    },

    render: function() {
      var resumes = this.props.resumes.map(function(resume, index) {
        var key = "resume-" + resume.id;
        return <ResumeItem resume={resume} key={key} />;
      });

      return (
        <div className="container">
          <div className="row">
            {resumes}
            <div className="resume-index-item-placeholder col-sm-12">
              <a href={this.props.createPage} className="btn btn-success create-new-button">
                <span className="glyphicon glyphicon-plus"></span>
                Create New
              </a>
            </div>
          </div>
        </div>
      );
    }
  });

  var ResumeItem = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    getDefaultProps: function() {
      return {

      };
    },

    componentDidMount: function() {

    },

    render: function() {
      var resume = this.props.resume;

      return (
        <div className="resume-index-item col-sm-12">
          <div className="row">
            <div className="col-sm-9">
              <div className="header">
                <a href={resume.show_page} className="header-title">{resume.name}</a>
              </div>
              <div className="descriptor">{resume.descriptor}</div>
              <div className="action-links">
                <a href={resume.edit_page} className="btn btn-primary btn-sm">Edit</a>
                <JibJob.ResumePublisher resume={resume} />
              </div>
            </div>
            <div className="col-sm-3">
              <div className="file-links">
                <a href={resume.user_pdf_file} className="btn btn-default btn-sm">
                  <span className="glyphicon glyphicon-file"></span>
                  PDF
                </a>
                <a href={resume.user_plaintext_file} className="btn btn-default btn-sm">
                  <span className="glyphicon glyphicon-font"></span>
                  Plain Text
                </a>
              </div>
            </div>
          </div>
        </div>
      );
    }
  })
}(window));