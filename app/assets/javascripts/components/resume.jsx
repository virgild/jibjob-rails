"use strict";

(function(App, window, $) {
  App.ResumeForm = React.createClass({
    propTypes: {
      saveURL: React.PropTypes.string.isRequired,
      sampleResume: React.PropTypes.string.isRequired,
      resume: React.PropTypes.object.isRequired,
    },

    getInitialState: function() {
      return {
        nameValue: "",
        slugValue: "",
        contentValue: "",
        isLoading: false
      };
    },

    componentDidMount: function() {

    },

    submitForm: function(e) {
      e.preventDefault();
      this.setState({isLoading: true});

      var self = this;
      var formData = {
        resume: {
          name: this.state.nameValue,
          slug: this.state.slugValue,
          content: this.state.contentValue
        }
      };

      $.post(this.props.saveURL, formData).done(function(data) {
        if (data.success) {
          var nextPage = data.redirect;
          window.location = nextPage;
        }
      }).fail(function(xhr, status) {
        window.alert("There are errors in your resume form entries.");
      }).always(function() {
        self.setState({isLoading: false});
      });
    },

    nameFieldChange: function(e) {
      var newName = e.target.value;
      var newSlug = newName.replace(/['/]/g, '').replace(/[ .,:-]/g, '-').toLocaleLowerCase();

      this.setState({ nameValue: newName, slugValue: newSlug });
    },

    slugFieldChange: function(e) {
      this.setState({slugValue: e.target.value});
    },

    contentFieldChange: function(e) {
      this.setState({contentValue: e.target.value});
    },

    loadExampleContent: function(e) {
      e.preventDefault();
      var self = this;

      $.get(this.props.sampleResume).done(function(data) {
        self.setState({contentValue: data});
      });
    },

    render: function() {
      return (
        <div className="page">
          <div className="page-header">
            <div className="container">
              <h4>New Resume</h4>
            </div>
          </div>
          <div className="container resume-form">
            <form action={this.props.saveURL} method="POST" className="form" onSubmit={this.submitForm}>
              <div className="form-group">
                <label>Name</label>
                <input type="text" name="resume[name]" value={this.state.nameValue} onChange={this.nameFieldChange}
                  className="form-control" autoComplete="off" spellCheck="false" placeholder="A private name for this resume" autoFocus="true" />
              </div>
              <div className="form-group">
                <label>Slug</label>
                <input type="text" name="resume[slug]" value={this.state.slugValue} onChange={this.slugFieldChange}
                  className="form-control" autoComplete="off" spellCheck="false" placeholder="A public identifier value like http://jibjob.co/resumes/[slug]" />
              </div>
              <div className="form-group">
                <label>Content</label>
                <a href="#" className="btn btn-xs btn-default pull-right" onClick={this.loadExampleContent}>Load Example</a>
                <textarea value={this.state.contentValue} placeholder="Resume content" onChange={this.contentFieldChange} className="form-control console" rows="25" />
              </div>
              <App.GlyphedButton type="submit" showLoading={this.state.isLoading} className="btn btn-success form-control" buttonType="success">
                <span>Create Resume</span>
              </App.GlyphedButton>
            </form>
          </div>
        </div>
      );
    }
  });
}(JibJob, window, $));