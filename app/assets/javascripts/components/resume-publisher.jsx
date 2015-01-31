(function(win) {
  $(function() {
    var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

    win.Publisher = React.createClass({
      getInitialState: function() {
        return { form_shown: false };
      },

      handleClick: function(e) {
        e.preventDefault();
        this.setState({form_shown: !this.state.form_shown});
      },

      render: function() {
        var form = null;

        if (this.state.form_shown) {
          form = <PublishForm {...this.props} />;
        } else {
          form = null;
        }

        return (
          <span>
            <a href="#" className="btn btn-info btn-sm" onClick={this.handleClick}>Publish</a>
            <ReactCSSTransitionGroup transitionName="animator">
              {form}
            </ReactCSSTransitionGroup>
          </span>
        );
      }
    });

    win.PublishForm = React.createClass({
      getInitialState: function() {
        return {
          slug_value: this.props.slug
        };
      },

      handleSubmit: function(e) {
        e.preventDefault();
        console.log("Submiting slug: " + this.state.slug_value);
      },

      handleChange: function(e) {
        this.setState({slug_value: event.target.value});
      },

      render: function() {
        var key = "publisher_form_" + this.props.resume_id;
        return (
          <form key={key} action="" method="POST" className="form form-inline" onSubmit={this.handleSubmit} style={{padding: "10px"}}>
            <label style={{'marginRight': '10px'}}>Slug:</label>
            <input type="text" placeholder="Slug text" value={this.state.slug_value} className="form-control" style={{ 'marginRight': '10px'}} onChange={this.handleChange}/>
            <button type="submit" className="btn btn-sm btn-default">Submit</button>
          </form>
        );
      }
    });
  });
}(this));