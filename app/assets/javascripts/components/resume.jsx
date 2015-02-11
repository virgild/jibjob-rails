"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeForm = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
      saveMethod: React.PropTypes.oneOf(['POST', 'PUT']).isRequired,
      saveURL: React.PropTypes.string.isRequired,
    },

    getInitialState: function() {
      return {
        isLoading: false
      };
    },

    componentDidMount: function() {
      var editor = ace.edit(this.refs.editor.getDOMNode());
      $(this.refs.editor.getDOMNode()).height(500);
      editor.setTheme("ace/theme/chrome");
      editor.getSession().setMode("ace/mode/text");
      editor.setValue(this.props.resume.content);

      editor.scrollToLine(0);
      editor.gotoLine(1);
      editor.clearSelection();

      var self = this;

      editor.getSession().on('change', function(e) {
        self.props.resume.content = editor.getValue();
      });
    },

    submitForm: function(e) {
      e.preventDefault();
      this.setState({isLoading: true});

      var self = this;
      var resume = this.props.resume;

      $.ajax({
        url: this.props.saveURL,
        data: {resume: resume},
        method: this.props.saveMethod,
      }).done(function(data) {
        var nextPage = data.meta.redirect;
        window.location = nextPage;
      }).fail(function(xhr, status) {
        self.setProps({
          resume: React.addons.update(self.props.resume, {
            $merge: xhr.responseJSON.resume
          })
        })
      }).always(function(xhr) {
        self.setState({isLoading: false});
      });
    },

    nameFieldChange: function(e) {
      var newName = e.target.value;
      var newSlug = newName.replace(/['/]/g, '').replace(/[ .,:-]/g, '-').toLocaleLowerCase();

      this.setProps({
        resume: React.addons.update(this.props.resume, {
          $merge: {name: newName, slug: newSlug}
        })
      });
    },

    slugFieldChange: function(e) {
      var newSlug = e.target.value;

      this.setProps({
        resume: React.addons.update(this.props.resume, {
          slug: {$set: newSlug}
        })
      });
    },

    loadExampleContent: function(e) {
      e.preventDefault();
      var self = this;
      var url = "https://s3.amazonaws.com/jibjob/examples/sample.resume";

      $.get(url).done(function(data) {
        self.props.resume.content = data;

        var editor = ace.edit("resume-editor");
        editor.setValue(data);
        editor.scrollToLine(0);
        editor.gotoLine(1);
        editor.clearSelection();
      });
    },

    render: function() {
      var resume = this.props.resume;
      return (
        <div className="container resume-form">
          <JibJob.ErrorDisplay model={resume} />
          <form action={this.props.saveURL} method="POST" className="form" onSubmit={this.submitForm}>
            <div className="form-group">
              <label>Name</label>
              <input type="text" name="resume[name]" value={resume.name} onChange={this.nameFieldChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="A private name for this resume" autoFocus="true" />
            </div>
            <div className="form-group">
              <label>Slug</label>
              <input type="text" name="resume[slug]" value={resume.slug} onChange={this.slugFieldChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="A public identifier value like http://jibjob.co/resumes/[slug]" />
            </div>
            <div className="form-group">
              <label>Content</label>
              <a href="#" className="btn btn-xs btn-default pull-right" onClick={this.loadExampleContent}>Load Example</a>
              <div className="editor" id="resume-editor" ref="editor">
              </div>
            </div>
            <JibJob.GlyphedButton type="submit" showLoading={this.state.isLoading} className="btn btn-success form-control" buttonType="success">
              <span>Save Resume</span>
            </JibJob.GlyphedButton>
          </form>
        </div>
      );
    }
  });
}(window));