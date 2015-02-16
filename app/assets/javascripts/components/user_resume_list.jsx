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
      var updatedAt = $(this.refs.updated_at.getDOMNode()).text();
      $(this.refs.updated_at.getDOMNode()).html(moment(Date.parse(updatedAt)).fromNow());
    },

    render: function() {
      var resume = this.props.resume;
      var pubURL = "/pub/" + resume.slug;

      if (resume.is_published) {
        var published = (
          <div>
            <span className="published">
              Published at <a href={resume.publish_url}>{resume.publish_url}</a>
            </span>
          </div>
        );
      }

      return (
        <div className="resume-index-item col-sm-12">
          <div className="row">
            <div className="col-sm-12">
              <div className="header">
                <a href={resume.show_page} className="header-title">{resume.name}</a>
                <span className="descriptor">{resume.descriptor}</span>
                <span className="updated_at bg-info">
                  Last updated: <span ref="updated_at">{resume.updated_at}</span>
                </span>
                {published}
                <div className="statslink">
                  <a href={resume.stats_page}>Stats Page</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      );
    }
  })
}(window));