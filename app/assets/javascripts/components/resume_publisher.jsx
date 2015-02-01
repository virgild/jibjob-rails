"use strict";

(function(window, $) {
  var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

  window.ResumePublisher = React.createClass({
    ViewStates: {
      UNPUBLISHED: 1,
      PUBLISHING: 2,
      PUBLISHED: 3,
      UNPUBLISHING: 4
    },

    getInitialState: function() {
      var resume = this.getResume();

      return {
        currentView: resume.is_published ? this.ViewStates.PUBLISHED : this.ViewStates.UNPUBLISHED,
        errors: []
      };
    },

    getResume: function() {
      return this.props.resume;
    },

    getPublishURL: function() {
      return this.getResume().publish_url;
    },

    getUnpublishURL: function() {
      return this.getResume().unpublish_url;
    },

    publishClicked: function(e) {
      e.preventDefault();

      (function(publisher) {
        publisher.setState({ currentView: publisher.ViewStates.PUBLISHING });

        publisher.publishSubmit().done(function(data) {
          publisher.setState({ currentView: publisher.ViewStates.PUBLISHED });
        }).fail(function(xhr, status) {
          console.log("ERROR");
        });
      }(this));
    },

    publishSubmit: function() {
      return $.post(this.getPublishURL());
    },

    unpublishClicked: function(e) {
      e.preventDefault();

      (function(publisher) {
        publisher.setState({ currentView: publisher.ViewStates.UNPUBLISHING });

        publisher.unpublishSubmit().done(function(data) {
          publisher.setState({ currentView: publisher.ViewStates.UNPUBLISHED });
        }).fail(function(xhr, status) {

        });
      }(this));
    },

    unpublishSubmit: function() {
      return $.post(this.getUnpublishURL());
    },

    render: function() {
      var resume = this.getResume();
      var cx = React.addons.classSet;
      var key = null;

      var classes = {
        'btn': true,
        'btn-default': true,
        'btn-sm': true
      };

      switch (this.state.currentView) {
        case this.ViewStates.UNPUBLISHED:
          key = 'publish-button';
          var clickHandler = this.publishClicked;
          var labelText = "Unpublished";
          var glyph = (<span className="glyphicon glyphicon-unchecked" />);
          classes['btn-default'] = true;
          classes['btn-info'] = false;
          break;
        case this.ViewStates.PUBLISHING:
          key = 'publishing-label';
          var clickHandler = null;
          var labelText = "Publishing...";
          var glyph = (<span className="glyphicon glyphicon-unchecked" />);
          break;
        case this.ViewStates.PUBLISHED:
          key = 'unpublish-button';
          var clickHandler = this.unpublishClicked;
          var labelText = "Published";
          var glyph = (<span className="glyphicon glyphicon-check" />);
          classes['btn-default'] = false;
          classes['btn-info'] = true;
          break;
        case this.ViewStates.UNPUBLISHING:
          key = 'unpublishing-label';
          var clickHandler = null;
          var labelText = "Unpublishing...";
          var glyph = (<span className="glyphicon glyphicon-check" />);
          break;
      }

      return (
        <a href="#publish" key={key} onClick={clickHandler} className={cx(classes)}>
          {glyph}
          {labelText}
        </a>
      );
    }
  });
}(window, $));