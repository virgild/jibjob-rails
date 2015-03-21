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
            <div className="resume-list-item placeholder">
              <a id="create-button" href={this.props.createPage}>
                <div className="thumb">
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

      if (resume.is_published) {
        var published = (
          <div className="published-marker">
            <span>PUBLISHED</span>
          </div>
        );
      }

      if (resume.access_code) {
        var lockFlag = (
          <span className="lock-flag icon fa fa-lock" />
        );
      }

      if (resume.recently_new) {
        var newRibbon = (
          <div className="resume-list-item__ribbon">
            <span>NEW</span>
          </div>
        );
      }

      return (
        <div className="col-md-3 col-sm-4 col-xs-12">
          <div className="resume-list-item">
            <a className="thumb-wrap" href={resume.show_page}>
              {newRibbon}
              <img className="thumb" src={resume.thumbnail} />
            </a>
            <a href={resume.show_page} className="name">{lockFlag}{resume.name}</a>
            {published}
            <div className="page-views-count" title="Resume page views">
              <span className="fa fa-eye icon" />
              {resume.total_page_views}
            </div>
          </div>
        </div>
      );
    }
  });
}(window));