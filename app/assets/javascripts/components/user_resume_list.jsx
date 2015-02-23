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
          <ul className="list-group resume-list">
            {resumes}
            <li className="resume-index-item-placeholder list-group-item">
              <a href={this.props.createPage} className="btn btn-success create-new-button">
                <span className="glyphicon glyphicon-plus"></span>
                Create New
              </a>
            </li>
          </ul>
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
      /*
      var updatedAt = $(this.refs.updated_at.getDOMNode()).text();
      $(this.refs.updated_at.getDOMNode()).html(moment(Date.parse(updatedAt)).fromNow());
      */
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
      } else {
        var published = (
          <div>
            <span className="unpublished">
              Unpublished
            </span>
          </div>
        );
      }

      return (
        <li className="resume-index-item list-group-item">
          <a href={resume.show_page} className="header-title">{resume.name}</a>
          <div className="descriptor">{resume.descriptor}</div>
          {published}
          <div className="statslink">
            <a href={resume.stats_page} className="label label-warning">Stats Page</a>
          </div>
        </li>
      );
    }
  })
}(window));