"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};
  var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

  global.JibJob.ResumePublisher = React.createClass({
    ViewStates: {
      UNPUBLISHED: 1,
      PUBLISHING: 2,
      PUBLISHED: 3,
      UNPUBLISHING: 4
    },

    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    getInitialState: function() {
      var resume = this.getResume();

      return {
        currentView: resume.is_published ? this.ViewStates.PUBLISHED : this.ViewStates.UNPUBLISHED,
        errors: []
      };
    },

    componentDidMount: function() {
      console.log(this.props);
    },

    getResume: function() {
      return this.props.resume;
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
      return $.ajax({
        url: this.getResume().show_page,
        data: {resume: {is_published: true}},
        method: "PUT",
      });
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
      return $.ajax({
        url: this.getResume().show_page,
        data: {resume: {is_published: false}},
        method: "PUT",
      });
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
        <div>
          <input type="checkbox"  />
          <a href="#publish" key={key} onClick={clickHandler}>
            {labelText}
          </a>
        </div>
      );
    }
  });
}(window));