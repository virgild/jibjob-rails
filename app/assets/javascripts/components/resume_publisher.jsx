(function(window, $) {
  window.ResumePublisher = React.createClass({
    getInitialState: function() {
      return {
        showing_publish_form: false,
        resume_is_published: this.props.resume.is_published
      };
    },

    getResume: function() {
      return this.props.resume;
    },

    getPublishURL: function() {
      return this.props.resume.publish_url;
    },

    render: function() {
      var resume = this.getResume();

      if (this.state.showing_publish_form) {
        return <PublishForm publisher={this} />
      } else if (this.state.resume_is_published) {
        return <PublicationDetails publisher={this} />
      } else {
        return <PublishButton publisher={this} />
      }
    }
  });

  var PublishButton = React.createClass({
    getInitialState: function() {
      return {};
    },

    handleClick: function(e) {
      e.preventDefault();
      this.props.publisher.setState({ showing_publish_form: true });
    },

    render: function() {
      return (
        <a href="#publish" onClick={this.handleClick} className="btn btn-info btn-sm">Publish</a>
      );
    }
  });

  /* */
  var PublishForm = React.createClass({
    getInitialState: function() {
      return {
        slug: this.props.publisher.getResume().slug
      };
    },

    cancelClicked: function(e) {
      e.preventDefault();

      var publisher = this.props.publisher;
      publisher.setState({ showing_publish_form: false });
    },

    formAccept: function(e) {
      e.preventDefault();

      var slug = this.state.slug;
      var form_data = $(this.refs.pubform.getDOMNode()).serialize();
      var publisher = this.props.publisher;
      $.post(publisher.getPublishURL(), form_data, function(data, status) {
        publisher.setState({ resume_is_published: true, showing_publish_form: false });
      });
    },

    slugChanged: function(e) {
      this.setState({ slug: e.target.value });
    },

    render: function() {
      var publisher = this.props.publisher;

      return (
        <span>
          <form className="form-inline" style={{display:"inline"}} onSubmit={this.formAccept} ref="pubform">
            <input type="hidden" name="utf8" value="✓" />
            <input type="hidden" name="authenticity_token" value={publisher.getResume().form_token} />
            <input type="hidden" name="resume[is_published]" value="true" />
            <input type="text" className="form-control small" name="resume[slug]" value={this.state.slug} onChange={this.slugChanged} placeholder="Enter slug" />
            <button type="submit" className="btn btn-success btn-sm">OK</button>
            <button onClick={this.cancelClicked} className="btn btn-warning btn-sm">Cancel</button>
          </form>
        </span>
      );
    }
  });

  /* */
  var PublicationDetails = React.createClass({
    getInitialState: function() {
      return {};
    },

    unpublishClicked: function(e) {
      e.preventDefault();
      var publisher = this.props.publisher;
      var unpublish_url = publisher.getResume().unpublish_url;

      $.post(unpublish_url, {}, function(data, status) {
        publisher.setState({ showing_publish_form: false, resume_is_published: false });
      });
    },

    render: function() {
      return (
        <span>
          <span>Published at [slug]</span>
          <button onClick={this.unpublishClicked}>Unpublish</button>
        </span>
      );
    }
  });
}(window, $));