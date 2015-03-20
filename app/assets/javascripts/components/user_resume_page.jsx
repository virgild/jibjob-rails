/** @jsx React.DOM */

(function(global){
  global.JibJob = global.JibJob || {};

  global.JibJob.UserResumePage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {

    },

    render: function() {
      var resume = this.props.resume;
      var origin = window.location.origin;
      var pub_url = origin + resume.publish_url;

      var accessCode = (function(access_code) {
        if (access_code) {
          return (
            <div className="access-code" title="Access code">
              <span className="fa fa-lock" /> {resume.access_code}
            </div>
          );
        }
      }(resume.access_code));

      var details = (function() {
        var published = (function(isPublished) {
          if (isPublished) {
            return (
              <div className="published-marker">
                <a href={resume.publish_url} target="_blank" title="Published link">
                  <span className="fa fa-external-link" />
                  PUBLISHED: /{resume.slug}
                </a>
              </div>
            );
          }
        }(resume.is_published));

        return (
          <div className="title">{resume.name} {published}</div>
        );
      }());

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
            </div>
          </div>
          <div className="row">
            <div className="col-sm-12">
              <div className="preview">
                <JibJob.PublicationPackagePanel pdf_url={resume.user_pdf_file} plaintext_url={resume.user_plaintext_file} />
                <JibJob.PublicationResume data={resume.structure} />
              </div>
            </div>
          </div>
        </div>
      );
    }
  });
}(window));