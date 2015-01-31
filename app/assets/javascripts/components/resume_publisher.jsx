(function(window, $) {
  var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

  window.ResumePublisher = React.createClass({
    views: {
      PUBLISH_BUTTON: 0,
      PUBLISH_FORM: 1,
      PUBLICATION_DETAILS: 2
    },

    getInitialState: function() {
      var initial_view = this.views.PUBLISH_BUTTON;
      var resume = this.getResume();

      if (resume.is_published) {
        initial_view = this.views.PUBLICATION_DETAILS;
      } else {
        initial_View = this.views.PUBLISH_BUTTON;
      }

      return {
        current_view: initial_view,
        slug: this.props.resume.slug,
        errors: []
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
      var element = null;

      switch (this.state.current_view) {
        case this.views.PUBLISH_BUTTON:
          element = <PublishButton publisher={this} key="publisher-button" />
          break;
        case this.views.PUBLISH_FORM:
          element = <PublishForm publisher={this} key="publisher-form" />
          break;
        case this.views.PUBLICATION_DETAILS:
          element = <PublicationDetails publisher={this} key="publisher-details" />
          break;
      }

      return (
        <ReactCSSTransitionGroup transitionName="publisher-element" component="span">
          {element}
        </ReactCSSTransitionGroup>
      );
    }
  });

  var PublishButton = React.createClass({
    getInitialState: function() {
      return {};
    },

    publishClicked: function(e) {
      e.preventDefault();

      var publisher = this.props.publisher;
      publisher.setState({ current_view: publisher.views.PUBLISH_FORM });
    },

    render: function() {
      return (
        <a href="#publish" onClick={this.publishClicked} className="btn btn-info btn-sm">Publish</a>
      );
    }
  });

  /* */
  var PublishForm = React.createClass({
    getInitialState: function() {
      return {
        slug: this.props.publisher.state.slug
      };
    },

    cancelClicked: function(e) {
      e.preventDefault();

      var publisher = this.props.publisher;
      publisher.setState({ current_view: publisher.views.PUBLISH_BUTTON });
    },

    formAccept: function(e) {
      e.preventDefault();

      var slug = this.state.slug;
      var form_data = $(this.refs.pubform.getDOMNode()).serialize();
      var publisher = this.props.publisher;

      $.post(publisher.getPublishURL(), form_data, function(data, status) {
        var new_slug = data.resume.slug;
        publisher.setState({ current_view: publisher.views.PUBLICATION_DETAILS, slug: data.resume.slug });
      }).fail(function() {

      });
    },

    slugChanged: function(e) {
      this.setState({ slug: e.target.value });
    },

    render: function() {
      var publisher = this.props.publisher;

      return (
        <span>
          <form className="form-inline publish-form" onSubmit={this.formAccept} ref="pubform">
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
      var publisher = this.props.publisher;

      return { slug: publisher.state.slug };
    },

    unpublishClicked: function(e) {
      e.preventDefault();
      var publisher = this.props.publisher;
      var unpublish_url = publisher.getResume().unpublish_url;

      $.post(unpublish_url, {}, function(data, status) {
        publisher.setState({ current_view: publisher.views.PUBLISH_BUTTON });
      });
    },

    render: function() {
      var slug = this.state.slug;

      return (
        <span>
          <span>Published at {slug}</span>
          <button onClick={this.unpublishClicked}>Unpublish</button>
        </span>
      );
    }
  });
}(window, $));