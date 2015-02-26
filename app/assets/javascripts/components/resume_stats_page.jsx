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
      var width = 700;
      var height = 200;
      var blockSize = Math.floor(width / 28);
      var times = ["12AM", "1AM", "2AM", "3AM", "4AM", "5AM", "6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "12PM", "1PM", "2PM", "3PM", "4PM", "5PM", "6PM", "7PM", "8PM", "9PM", "10PM", "11PM"];
      // var colors = ["#fff", "#ffffcc", "#ffeda0", "#fed976", "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "#b10026"];
      var colors = ['rgb(255,255,204)','rgb(255,237,160)','rgb(254,217,118)','rgb(254,178,76)','rgb(253,141,60)','rgb(252,78,42)','rgb(227,26,28)','rgb(189,0,38)','rgb(128,0,38)'];
      var colorScale = d3.scale.quantile()
        .domain([0, d3.max(this.props.resumeStats, function(d) { return d[4] })])
        .range(colors);
      var data = this.props.resumeStats.map(function(d) {
        return { year: d[0], month: d[1], day: d[2], hour: d[3], count: d[4] }
      });

      var days = d3.set(
        data.map(function(d) { return d.day; })
          .filter(function(d) { return (typeof d != undefined) ? d !== null : false})
      ).values();

      var svg = d3.select(".chart").append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g");

      var dayLabels = svg.selectAll(".day")
        .data(days)
        .enter().append("text")
        .text(function(d) { return d; })
        .attr("x", 48)
        .attr("y", function(d, i) { return 36 + (i * blockSize); })
        .style("text-anchor", "end")
        .attr("transform", "translate(0, " + blockSize / 1.5 + ")")
        .attr("fill", "#000")
        .attr("class", "day");

      var timeLabels = svg.selectAll(".time")
        .data(times)
        .enter().append("text")
        .text(function(d) { return d; })
        .attr("x", function(d, i) { return 70 + (i * blockSize); })
        .attr("y", 30)
        .style("font-size", "8px")
        .style("text-anchor", "middle")
        .attr("class", "time")

      var hourBlocks = svg.selectAll(".hour")
        .data(data)
        .enter().append("rect")
        .attr("class", "hour")
        .attr("x", function(d) { return 60 + (d.hour * blockSize); })
        .attr("y", function(d, i) { return 40 + ((d.day - d3.min(days)) * blockSize); })
        .attr("width", blockSize - 1)
        .attr("height", blockSize - 1)
        .style("fill", function(d) { return colorScale(d.count); });
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