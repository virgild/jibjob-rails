/** @jsx React.DOM */

(function(global){
  global.JibJob = global.JibJob || {};

  var cx = React.addons.classSet;

  global.JibJob.GlyphedButton = React.createClass({
    propTypes: {
      glyph: React.PropTypes.string.isRequired,
      clickHandler: React.PropTypes.func,
      showLoading: React.PropTypes.bool
    },

    getDefaultProps: function() {
      return {
        glyph: "ok",
        clickHandler: null
      };
    },

    getInitialState: function() {
      return {
      };
    },

    clickHandler: function(e) {
      if (this.props.showLoading) {
        e.preventDefault();
        return;
      }

      if (this.props.clickHandler) {
        this.props.clickHandler(e);
      }
    },

    render: function() {
      var glyphClasses = {
        "glyphicon": true
      };
      glyphClasses["glyphicon-" + this.props.glyph] = true;

      var glyph = <span className={cx(glyphClasses)} />;

      var buttonContent = this.props.children;
      if (!buttonContent) {
        buttonContent = "Submit";
      }

      var loadingIndicator = '';
      if (this.props.showLoading) {
        loadingIndicator = '...';
      }

      return (
        <button {...this.props} onClick={this.clickHandler}>
          {glyph}
          {buttonContent}
          {loadingIndicator}
        </button>
      );
    }
  });
}(window));