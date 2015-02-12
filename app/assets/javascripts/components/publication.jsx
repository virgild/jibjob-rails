"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.PublicationPage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {
      global.JibJob.CurrentPage = this;
    },

    mouseEnter: function(e) {
      $(this.refs.panel.getDOMNode()).removeClass('inactive');
    },

    mouseLeave: function(e) {
      $(this.refs.panel.getDOMNode()).addClass('inactive');
    },

    render: function() {
      return (
        <div className="page">
          <div className="container" onMouseEnter={this.mouseEnter} onMouseLeave={this.mouseLeave}>
            <Panel ref="panel" data={this.props.resume} />
            <Resume data={this.props.resume} />
            <Footer />
          </div>
        </div>
      );
    }
  });

  var Resume = React.createClass({
    propTypes: {
      data: React.PropTypes.object.isRequired,
    },

    render: function() {
      var resume = this.props.data;
      var struct = resume.structure;

      var sections = struct.sections.map(function(section, index) {
        var key = "section-" + index;
        return <Section data={section} key={key} index={index} />;
      });

      return (
        <div className="resume">
          <div className="resume-header">
            <div className="fullname">{struct.full_name}</div>
            <div className="address1">{struct.address1}</div>
            <div className="address2">{struct.address2}</div>
            <div className="telephone">{struct.telephone}</div>
            <div className="email">{struct.email}</div>
            <div className="url">{struct.url}</div>
          </div>
          <div className="sections">
            {sections}
          </div>
        </div>
      );
    }
  });

  var Section = React.createClass({
    propTypes: {
      data: React.PropTypes.object.isRequired,
      index: React.PropTypes.number,
    },

    componentDidMount: function() {

    },

    render: function() {
      var section = this.props.data;
      var sectionIndex = this.props.index;

      if (section.para) {
        var para = <div className="para">
          {section.para}
        </div>;
      }

      if (section.items && section.items.length > 0) {
        var items = (function(items){
          var elements = items.map(function(item, index) {
            var key = "section-" + sectionIndex + "-listitem-" + index;
            return <li key={key}>
              {item}
            </li>;
          });
          return <ul>
            {elements}
          </ul>;
        }(section.items));
      }

      if (section.periods && section.periods.length > 0) {
        var periods = section.periods.map(function(period, index) {
          var key = "section-" + sectionIndex + "-period-" + index;
          return <Period data={period} index={index} key={key} />;
        });
      }

      return (
        <div className="section">
          <div className="section-title">{section.title}</div>
          {para}
          {items}
          {periods}
        </div>
      );
    }
  });

  var Period = React.createClass({
    propTypes: {
      data: React.PropTypes.object.isRequired,
      index: React.PropTypes.number,
    },

    componentDidMount: function() {

    },

    render: function() {
      var period = this.props.data;
      var periodIndex = this.props.index;

      var items = (function(items) {
        if (items && items.length > 0) {
          var itemlist = items.map(function(item, index) {
            var key = "period-" + periodIndex + "-item-" + index;
            return <li key={key}>{item}</li>;
          });
          return <ul className="period-items">
            {itemlist}
          </ul>;
        }
      }(period.items));

      return (
        <div className="period">
          <div className="period-title">{period.title}</div>
          <div className="organization">{period.organization} - {period.location}</div>
          <div className="date">{period.dtstart} - {period.dtend}</div>
          {items}
        </div>
      );
    }
  });

  var Panel = React.createClass({
    propTypes: {
      data: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {

    },

    render: function() {
      return (
        <div className="control-panel inactive">
          <span className="desc">Other formats:</span>
          <a href={this.props.data.pdf_file_url} className="btn btn-xs">
            <span className="glyphicon glyphicon-file" />
            PDF
          </a>
          <a href={this.props.data.plaintext_file_url} className="btn btn-xs">
            <span className="glyphicon glyphicon-file" />
            Plain Text
          </a>
          <a href={this.props.data.package_url} className="btn btn-xs">
            <span className="glyphicon glyphicon-file" />
            Zip
          </a>
        </div>
      );
    }
  });

  var Footer = React.createClass({
    render: function() {
      return (
        <div className="footer">
          <div className="powered">
            Powered by <a href="http://jibjob.co">jibjob.co</a>.
          </div>
        </div>
      );
    }
  });

}(window));