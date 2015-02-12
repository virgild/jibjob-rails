"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.PublicationPage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {
    },

    render: function() {
      var resume = this.props.resume;
      var struct = resume.structure;

      var sections = struct.sections.map(function(section, index) {
        var key = "section-" + index;
        return <Section data={section} key={key} index={index} />;
      });

      return (
        <div className="page">
          <div className="resume">
            <div className="fullname">{struct.full_name}</div>
            <div className="">{struct.address1}</div>
            <div className="">{struct.address2}</div>
            <div className="">{struct.telephone}</div>
            <div className="">{struct.email}</div>
            <div className="">{struct.url}</div>
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
          <h3>{section.title}</h3>
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
          <h4>{period.title}</h4>
          <div className="organization">{period.organization}</div>
          <div className="location">{period.location}</div>
          <div className="date">{period.dtstart} - {period.dtend}</div>
          {items}
        </div>
      );
    }
  });

}(window));