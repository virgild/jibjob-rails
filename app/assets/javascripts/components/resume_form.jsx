/** @jsx React.DOM */

(function(global){
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeForm = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
      saveMethod: React.PropTypes.oneOf(['POST', 'PUT']).isRequired,
      saveURL: React.PropTypes.string.isRequired,
      usePlainEditor: React.PropTypes.bool,
      nameMaxLength: React.PropTypes.number.isRequired,
      slugMaxLength: React.PropTypes.number.isRequired,
      getStartedURL: React.PropTypes.string,
      showExampleLoader: React.PropTypes.bool
    },

    getInitialState: function() {
      return {
        isLoading: false
      };
    },

    componentDidMount: function() {
      if (this.props.usePlainEditor != true) {
        var editor = ace.edit(this.refs.editor.getDOMNode());
        $(this.refs.editor.getDOMNode()).height(1000);
        editor.setTheme("ace/theme/chrome");
        editor.renderer.setShowGutter(false);
        editor.renderer.setPrintMarginColumn(false);
        editor.getSession().setMode("ace/mode/text");
        editor.setValue(this.props.resume.content);

        editor.scrollToLine(0);
        editor.gotoLine(1);
        editor.clearSelection();

        var self = this;

        editor.getSession().on('change', function(e) {
          self.props.resume.content = editor.getValue();
        });
      }

      this.startCapturingShortcuts();
    },

    startCapturingShortcuts: function() {
      var self = this;
      $(global).bind('keydown', function(event) {
        if (event.ctrlKey || event.metaKey) {
          var letter = (String.fromCharCode(event.which)).toLowerCase();
          switch(letter) {
            case 's':
              event.preventDefault();
              self.submitForm(event);
              break;
            default:
              break;
          }
        }
      });
    },

    submitForm: function(e) {
      e.preventDefault();
      this.setState({isLoading: true});

      document.activeElement.blur();
      $("input").blur();

      var self = this;
      var resume_data = {
        name: this.props.resume.name,
        slug: this.props.resume.slug,
        is_published: this.props.resume.is_published,
        access_code: this.props.resume.access_code,
        content: this.props.resume.content
      };

      $.ajax({
        url: this.props.saveURL,
        data: {resume: resume_data},
        method: this.props.saveMethod,
      }).done(function(data) {
        if (data.meta.redirect) {
          window.location.href = data.meta.redirect;
        } else {
          try {
            self.setProps({
              resume: React.addons.update(self.props.resume, {
                $merge: data.resume
              })
            });
          } catch(error) {
            console.error(error);
          }
          self.showSaveNotification();
        }
      }).fail(function(xhr, status) {
        try {
          self.setProps({
            resume: React.addons.update(self.props.resume, {
              $merge: xhr.responseJSON.resume
            })
          });
        } catch (error) {
          console.error(error);
        }
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

    isPublishedChange: function(e) {
      var newValue = e.target.checked;

      this.setProps({
        resume: React.addons.update(this.props.resume, {
          is_published: {$set: newValue}
        })
      });
    },

    accessCodeChange: function(e) {
      var newValue = e.target.value;

      this.setProps({
        resume: React.addons.update(this.props.resume, {
          access_code: {$set: newValue}
        })
      });
    },

    contentChange: function(e) {
      var newContent = e.target.value;

      this.setProps({
        resume: React.addons.update(this.props.resume, {
          content: {$set: newContent}
        })
      });
    },

    loadExampleContent: function(e) {
      e.preventDefault();
      var self = this;
      var url = this.props.sampleURL;

      $.get(url).done(function(data) {
        var newContent = data;

        self.setProps({
          resume: React.addons.update(self.props.resume, {
            content: {$set: newContent}
          })
        });

        if (self.props.usePlainEditor != true) {
          var editor = ace.edit("resume-editor");
          editor.setValue(newContent);
          editor.scrollToLine(0);
          editor.gotoLine(1);
          editor.clearSelection();
        }
      });
    },

    showSaveNotification: function() {
      $.notify({
        message: "Resume saved.",
        icon: "fa fa-spinner fa-spin"
      }, {
        type: 'success',
        allow_dismiss: true,
        delay: 1000,
        animate: {
          enter: 'animated fadeInRight',
          exit: 'animated fadeOutRight'
        }
      });
    },

    render: function() {
      var resume = this.props.resume;
      var origin = window.location.origin;
      var pub_url = origin + "/" + resume.slug;

      if (resume.new_record == false) {
        var isPublishedGroup = (
          <div className="form-group">
            <label htmlFor="resume_is_published">Publish now</label>
            <br/>
            <label>
              <input id="resume_is_published" type="checkbox" name="resume[is_published]" checked={resume.is_published} onChange={this.isPublishedChange} className="" />
              <span style={{paddingLeft: "10px", fontWeight: "normal"}}>Published to {pub_url}</span>
            </label>
          </div>
        );
      }

      if (this.props.usePlainEditor) {
        var editor = (
          <textarea id="resume_content" name="resume[content]" value={this.props.resume.content} onChange={this.contentChange} className="resume-form__content form-control" rows="40" />
        );
      } else {
        var editor = (
          <div className="editor" id="resume-editor" ref="editor">
          </div>
        );
      }

      if (this.props.showExampleLoader) {
        var exampleLoader = (
          <a href="#" className="btn btn-xs btn-default pull-right" onClick={this.loadExampleContent}>Load Example</a>
        );
      }

      return (
        <div className="container resume-form">
          <JibJob.ErrorDisplay model={resume} />
          <form action={this.props.saveURL} method="POST" className="form" onSubmit={this.submitForm}>
            <div className="form-group">
              <label htmlFor="resume_name">Name</label>
              <input type="text" id="resume_name" name="resume[name]" value={resume.name} onChange={this.nameFieldChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="Name" autoFocus="true"
                autoCorrect="off" autoCapitalize="sentence" maxLength={this.props.nameMaxLength} />
              <p className="help-block">Your private name for this resume</p>
            </div>
            <div className="form-group">
              <label htmlFor="resume_slug">Link Name</label>
              <input type="text" id="resume_slug" name="resume[slug]" value={resume.slug} onChange={this.slugFieldChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="Link name"
                autoCorrect="off" autoCapitalize="none" maxLength={this.props.slugMaxLength} />
              <p className="help-block">
                A public name that identifies your resume. (i.e. {origin}/my-resume)
              </p>
            </div>
            {isPublishedGroup}
            <div className="form-group">
              <label htmlFor="resume_access_code">Access Code</label>
              <input type="text" id="resume_access_code" name="resume[access_code]" value={resume.access_code} onChange={this.accessCodeChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="Access code" autoCorrect="off"
                autoCapitalize="characters" maxLength="16" />
                <p className="help-block">The viewer will be required to enter this access code when specified</p>
            </div>
            <div className="form-group">
              <label htmlFor="resume_content">Content</label>
              {exampleLoader}
              <p className="help-block">
                Read <a href={this.props.getStartedURL} target="_blank">'Get Started'</a> for an overview of composing resumes.
                Press <kbd>Ctrl + S</kbd> or <kbd>&#8984; + S</kbd> while editing to save.
              </p>
              {editor}
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