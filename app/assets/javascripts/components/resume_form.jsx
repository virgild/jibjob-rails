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
      showExampleLoader: React.PropTypes.bool,
      tabletView: React.PropTypes.bool
    },

    getInitialState: function() {
      return {
        isLoading: false,
        name: this.props.resume.name,
        slug: this.props.resume.slug,
        isPublished: this.props.resume.is_published,
        accessCode: this.props.resume.access_code,
        theme: this.props.resume.current_theme,
        content: this.props.resume.content,
        contentChanged: true,
        errors: this.props.resume.errors
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

      if (this.state.isLoading) {
        return;
      }

      this.setState({isLoading: true});

      document.activeElement.blur();
      $("input").blur();

      var self = this;
      var resume_data = {
        name: this.state.name,
        slug: this.state.slug,
        is_published: this.state.isPublished,
        access_code: this.state.accessCode,
        theme: this.state.theme
      };

      if (this.state.contentChanged) {
        resume_data.content = this.state.content;
      }

      $.ajax({
        url: this.props.saveURL,
        data: {resume: resume_data},
        method: this.props.saveMethod,
      }).done(function(data) {
        if (data.meta.redirect) {
          window.location.href = data.meta.redirect;
        } else {
          try {
            self.setState({
              name: data.resume.name,
              slug: data.resume.slug,
              isPublished: data.resume.is_published,
              accessCode: data.resume.access_code,
              theme: data.resume.theme,
              content: data.resume.content,
              contentChanged: false,
              errors: data.resume.errors
            });

            self.showSaveNotification();
          } catch(error) {
            console.error(error);
          }
        }
      }).fail(function(xhr, status) {
        try {
          self.setState({errors: xhr.responseJSON.resume.errors});
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
      this.setState({name: newName, slug: newSlug});
    },

    slugFieldChange: function(e) {
      var newValue = e.target.value;
      this.setState({slug: newValue});
    },

    isPublishedChange: function(e) {
      var newValue = e.target.checked;
      this.setState({isPublished: newValue});
    },

    accessCodeChange: function(e) {
      var newValue = e.target.value;
      this.setState({accessCode: newValue});
    },

    themeChange: function(e) {
      var newValue = e.target.value;
      this.setState({theme: newValue});
    },

    contentChange: function(e) {
      var newValue = e.target.value;
      this.setState({content: newValue, contentChanged: true});
    },

    loadExampleContent: function(e) {
      e.preventDefault();
      var self = this;
      var url = this.props.sampleURL;

      $.get(url).done(function(data) {
        var newContent = data;
        self.setState({content: data, contentChanged: true});
      });
    },

    showSaveNotification: function() {
      $.notify({
        message: "Resume saved.",
        icon: ""
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

    themeOptions: function() {
      var themes = _.without(this.props.themes, 'default').sort();

      var defaultOption = (
        <optgroup key="default_theme">
          <option value="default" key="theme_option_default">Default</option>
        </optgroup>
      );

      var options = themes.map(function(theme, n) {
        var key = "theme_option_" + theme;
        var name = s(theme).capitalize().value();
        return (
          <option value={theme} key={key}>{name}</option>
        );
      });

      return [
        defaultOption,
        <optgroup key="custom_themes" label="Custom Themes">
          {options}
        </optgroup>
      ];
    },

    render: function() {
      var resume = this.props.resume;
      // var origin = global.location.origin;
      var origin = "";

      if (this.state.slug) {
        var pub_url = origin + "/" + this.state.slug;
      } else {
        var pub_url = origin + "/" + "_________" ;
      }

      var isPublishedGroup = (
        <div className="form-group">
          <label htmlFor="resume_is_published">Publish now</label>
          <br/>
          <label>
            <input id="resume_is_published" type="checkbox" name="resume[is_published]" checked={this.state.isPublished} onChange={this.isPublishedChange} className="" />
            <span style={{paddingLeft: "10px", fontWeight: "normal"}}>Published to {pub_url}</span>
          </label>
        </div>
      );

      if (this.props.usePlainEditor) {
        var editor = (
          <textarea id="resume_content" name="resume[content]" value={this.state.content} onChange={this.contentChange} className="resume-form__content form-control" rows="40" />
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

      if (this.state.isLoading) {
        var submitButton = (
          <button className="btn btn-warning form-control save-button" disabled="true">
            <div>
              <span className="icon fa fa-spin fa-spinner" />
              <span>Saving</span>
            </div>
          </button>
        );
      } else {
        var submitButton = (
          <button className="btn btn-success form-control save-button">
            <div>
              <span>Save</span>
            </div>
          </button>
        );
      }

      var containerClasses = { 'resume-form': true };
      if (this.props.tabletView) {
        containerClasses['tablet-view'] = true;
      }
      containerClasses = classNames(containerClasses);

      return (
        <div className={containerClasses}>
          <JibJob.ErrorDisplay errors={this.state.errors} />
          <form action={this.props.saveURL} method="POST" className="form" onSubmit={this.submitForm}>
            <div className="form-group">
              <label htmlFor="resume_name">Name</label>
              <input type="text" id="resume_name" name="resume[name]" value={this.state.name} onChange={this.nameFieldChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="Name" autoFocus="true"
                autoCorrect="off" autoCapitalize="sentence" maxLength={this.props.nameMaxLength} />
              <p className="help-block">Your private name for this resume</p>
            </div>
            <div className="form-group">
              <label htmlFor="resume_slug">Link Name</label>
              <input type="text" id="resume_slug" name="resume[slug]" value={this.state.slug} onChange={this.slugFieldChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="Link name"
                autoCorrect="off" autoCapitalize="none" maxLength={this.props.slugMaxLength} />
              <p className="help-block">
                A public name that identifies your resume. (i.e. {origin}/my-resume)
              </p>
            </div>
            {isPublishedGroup}
            <div className="form-group">
              <label htmlFor="resume_access_code">Access Code</label>
              <input type="text" id="resume_access_code" name="resume[access_code]" value={this.state.accessCode} onChange={this.accessCodeChange}
                className="form-control" autoComplete="off" spellCheck="false" placeholder="Access code" autoCorrect="off"
                autoCapitalize="characters" maxLength="16" />
                <p className="help-block">The viewer will be required to enter this access code when specified</p>
            </div>
            <div className="form-group">
              <label htmlFor="resume_theme">Theme</label>
              <select className="form-control" id="resume_theme" name="resume[theme]" value={this.state.theme} onChange={this.themeChange}>
                {this.themeOptions()}
              </select>
            </div>
            <div className="form-group">
              <label htmlFor="resume_content">Content</label>
              {exampleLoader}
              <p className="help-block">
                Read <a href={this.props.getStartedURL} target="_blank">'Get Started'</a> for an overview of composing resumes.
                <span className="hidden-xs">Press <kbd>Ctrl + S</kbd> or <kbd>&#8984; + S</kbd> while editing to save.</span>
              </p>
              {editor}
            </div>
            {submitButton}
          </form>
        </div>
      );
    }
  });
}(window));