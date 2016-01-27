(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeListPendingItem = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    touchStart: function(e) {
      $(e.target).addClass("touched");
    },

    touchEnd: function(e) {
      $(e.target).removeClass("touched");
    },

    touchCancel: function(e) {
      $(e.target).removeClass("touched");
    },

    render: function() {
      var resume = this.props.resume;

      if (resume.is_published) {
        var published = (
          <div className="published-marker">
            <span>Published</span>
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

      var resumeId = "resume_" + resume.id;

      return (
        <div className="col-md-3 col-sm-4 col-xs-12">
          <div id={resumeId} className="resume-list-item pending" onTouchStart={this.touchStart} onTouchEnd={this.touchEnd} onTouchCancel={this.touchCancel}>
            <a className="thumb-wrap" href={resume.show_page}>
              {newRibbon}
              <div className="pending-indicator">
                <span className="icon fa fa-spin fa-spinner" />
              </div>
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
