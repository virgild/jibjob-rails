/** @jsx React.DOM */

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeList = React.createClass({
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
        return <ResumeItem resume={resume} key={key} />;
      });

      if (this.props.showCreateButton) {
        var createButton = (
          <div className="col-md-3 col-sm-4 col-xs-12">
            <div className="resume-list-item resume-list-item__placeholder">
              <a id="create-button" href={this.props.createPage}>
                <div className="resume-list-item__thumb">
                  <span className="glyphicon glyphicon-plus icon"/>
                  <br/>
                  Create
                </div>
              </a>
            </div>
          </div>
        );
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
          <div className="resume-list-item__published">
            <span className="fa fa-external-link">&nbsp;</span>
            <a href={resume.publish_url} target="__blank">Published at {resume.publish_url}</a>
          </div>
        );
      } else {
        var published = (
          <div className="resume-list-item__unpublished">
            Unpublished
          </div>
        );
      }

      if (resume.access_code) {
        var accessCode = (
          <div className="resume-list-item__access-code">
            Access code: {resume.access_code}
          </div>
        );
      }

      if (resume.recently_new) {
        var newRibbon = (
          <div className="resume-list-item__ribbon">
            <span>NEW</span>
          </div>
        );
      }

      var pageCountIndicator = (function() {
        return (
          <div className="pdf-page-count" title={resume.pdf_page_count + ' pages'}>
            <span className="fa fa-copy" />
            {resume.pdf_page_count}
          </div>
        );
      }());

      var pageViewsIndicator = (function() {
        return (
          <div className="page-views-count" title="Resume page views">
            <span className="fa fa-compass" />
            {resume.total_page_views}
          </div>
        );
      }());

      return (
        <div className="col-md-3 col-sm-4 col-xs-12">
          <div className="resume-list-item">
            <a className="resume-list-item__thumb-wrap" href={resume.show_page}>
              {newRibbon}
              <img className="resume-list-item__thumb" src={resume.thumbnail} />
            </a>
            <a href={resume.show_page} className="resume-list-item__name">{resume.name}</a>
            {published}
            {accessCode}
            {pageCountIndicator}
            {pageViewsIndicator}
            <div className="page-links">
              <a className="stats-link" href={resume.stats_page}>
                <span className="fa fa-bar-chart"></span>
                Stats
              </a>
            </div>
          </div>
        </div>
      );
    }
  });
}(window));