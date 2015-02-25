"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeStatsPage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
      pageViews: React.PropTypes.array.isRequired,
      resumeStats: React.PropTypes.array,
    },

    componentDidMount: function() {
      console.log(this.props);
      global.JibJob.CurrentPage = this;

      this.buildChart();
    },

    buildChart: function() {
      var chart = d3.select(".chart");

      var dayBar = chart.selectAll("div.chart")
        .data(this.props.resumeStats)
        .enter().append("div").attr("class", "day");

      dayBar.append("div")
        .text(function(d) { return d[0]; });

      var timesBar = dayBar.selectAll("div.times")
        .data(function(d) { return d[1]; })
        .enter().append("span").attr("class", "times")
        .text(function(d) { return d[1]; });
    },

    render: function() {
      var resume = this.props.resume;

      return (
        <div className="page resume-stats-page">
          <ol className="breadcrumb">
            <li><a href={this.props.resumesPage}>My Resumes</a></li>
            <li><a href={resume.show_page}>{resume.name}</a></li>
            <li>Stats</li>
          </ol>
          <div className="page-header">
            <div className="container">
              <h3>{resume.name} Stats</h3>
            </div>
          </div>
          <div className="container">
            <div className="summary">
              <h4>Summary</h4>
              <div>Total Views: {resume.total_page_views}</div>
            </div>
            <h4>Graph</h4>
            <div className="chart">
            </div>
            <PublicationViewList resume={resume} pageViews={this.props.pageViews} />
          </div>
        </div>
      );
    }
  });

  var PublicationViewList = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
      pageViews: React.PropTypes.array.isRequired,
    },

    componentDidMount: function() {

    },

    render: function() {
      var items = this.props.pageViews.map(function(view, index) {
        var key = "pubview-" + index;
        return <PublicationViewListItem viewData={view} key={key} />;
      });

      return (
        <div>
          <h4>Page Views</h4>
          {items}
        </div>
      );
    }
  });

  var PublicationViewListItem = React.createClass({
    propTypes: {
      viewData: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {
    },

    render: function() {
      var data = this.props.viewData;

      var location = (function(city, state, country) {
        return (
          <div className="col-sm-9">
            <span className="field-label">Location:</span> <span className="field-value">{city}, {state}, {country}</span>
          </div>
        );
      }(data.city, data.state, data.country));

      return (
        <div className="pubview row">
          <div className="col-sm-6"><span className="field-label">Date:</span> <span className="field-value">{data.created_at}</span></div>
          <div className="col-sm-6 ipaddr"><span className="field-label">IP:</span> <span className="field-value">{this.props.viewData.ip_addr}</span></div>
          {location}
          <div className="col-sm-12"><span className="field-label">URL:</span> <span className="field-value">{this.props.viewData.url}</span></div>
          <div className="col-sm-12"><span className="field-label">Referrer:</span> <span className="field-value">{this.props.viewData.referrer}</span></div>
          <div className="col-sm-12"><span className="field-label">User Agent:</span> <span className="field-value">{this.props.viewData.user_agent}</span></div>
        </div>
      );
    }
  });
}(window));