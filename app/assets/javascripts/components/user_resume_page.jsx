/** @jsx React.DOM */

(function(global){
  global.JibJob = global.JibJob || {};

  global.JibJob.UserResumePage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    getInitialState: function() {
      return {
        isUpdating: false
      };
    },

    componentDidMount: function() {

    },

    publishResume: function(e) {
      e.preventDefault();

      if (this.state.isUpdating) {
        return;
      }

      this.setState({ isUpdating: true });

      var self = this;

      $.ajax({
        url: this.props.resume.show_page,
        data: { resume: { is_published: true } },
        method: "PUT"
      }).done(function(data) {
        self.props.resume.is_published = data.resume.is_published;
      }).fail(function(xhr, status) {

      }).always(function() {
        self.setState({isUpdating: false});
      });
    },

    unpublishResume: function(e) {
      e.preventDefault();

      if (this.state.isUpdating) {
        return;
      }

      this.setState({ isUpdating: true });

      var self = this;

      $.ajax({
        url: this.props.resume.show_page,
        data: { resume: {is_published: false} },
        method: "PUT"
      }).done(function(data) {
        self.props.resume.is_published = data.resume.is_published;
      }).fail(function(xhr, status) {

      }).always(function() {
        self.setState({isUpdating: false});
      });
    },

    render: function() {
      var resume = this.props.resume;
      var origin = window.location.origin;
      var pub_url = origin + resume.publish_url;
      var self = this;

      // Access code
      if (resume.access_code) {
        var accessCode = (
          <div className="access-code" title="Access code">
            <span className="fa fa-lock" /> {resume.access_code}
          </div>
        );
      }

      // Publish Toggler
      if (this.props.resume.is_published) {
        var publishToggler = (
          <div className="publish-toggler">
            <a href="#" onClick={self.unpublishResume} className="published">
              <span className="icon unpublished fa fa-toggle-off" />
              PUBLISHED
            </a>
          </div>
        );
      } else {
        var publishToggler = (
          <div className="publish-toggler">
            <a href="#" onClick={self.publishResume} className="unpublished">
              <span className="icon published fa fa-toggle-on" />
              UNPUBLISHED
            </a>
          </div>
        );
      }

      // Title
      var details = (
        <div className="title">{resume.name}{publishToggler}</div>
      );

      // Publish URL
      if (resume.is_published) {
        var publishURL = (
          <div className="publish-url">
            <a title="Publish URL" href={pub_url} target="_blank">{pub_url}</a>
          </div>
        );
      } else {
        var publishURL = (
          <div className="publish-url">
            <span>{pub_url}</span>
          </div>
        );
      }

      return (
        <div className="container">
          <div className="row">
            <div className="col-sm-12">
              <div className="details">
                {details}
                <div className="buttons">
                  <a href={resume.edit_page} title="Edit">
                    <span className="fa fa-edit" />
                  </a>
                  <a href={resume.stats_page} title="Stats">
                    <span className="fa fa-bar-chart" />
                  </a>
                  <a href={resume.delete_page} title="Delete">
                    <span className="fa fa-trash-o" />
                  </a>
                </div>
                {publishURL}
                <div className="dates">
                  <div title="Created at">
                    <span className="fa fa-plus-square" /> {resume.created_at}
                  </div>
                  <div title="Last updated">
                    <span className="fa fa-clock-o" /> {resume.updated_at}
                  </div>
                </div>
                {accessCode}
                <div className="properties">
                  <div className="item page-count" title="Number of pages">
                    <span className="fa fa-copy" /> {resume.pdf_page_count}
                  </div>
                  <div className="item page-views" title="Page views">
                    <span className="fa fa-eye" /> {resume.total_page_views}
                  </div>
                </div>
              </div>
              <div>
                <a href={resume.show_page + '.pdf'} style={{color: '#fff', fontSize: "12px"}}>PDF</a>
                <span> | </span>
                <a href={resume.show_page + '.xml'} style={{color: '#fff', fontSize: "12px"}}>XML</a>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-sm-12">
              <div className="preview">
                <JibJob.PublicationPackagePanel pdf_url={resume.user_pdf_file} plaintext_url={resume.user_plaintext_file} />
              </div>
            </div>
          </div>
        </div>
      );
    }
  });
}(window));