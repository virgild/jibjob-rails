"use strict";

(function(global) {
  global.JibJob = global.JibJob || {};

  global.JibJob.ResumeStatsPage = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {
      console.log(this.props);
    },

    render: function() {
      var resume = this.props.resume;

      return (
        <div className="page">
          <ol className="breadcrumb">
            <li><a href="">My Resumes</a></li>
            <li><a href={resume.show_page}>{resume.name}</a></li>
            <li>Stats</li>
          </ol>
          <div className="page-header">
            <div className="container">
              <h3>{resume.name} Stats</h3>
            </div>
          </div>
          <div className="container">
            <div className="">
              <PublicationViewList resume={resume} />
            </div>
          </div>
        </div>
      );
    }
  });

  var PublicationViewList = React.createClass({
    propTypes: {
      resume: React.PropTypes.object.isRequired,
    },

    componentDidMount: function() {

    },

    render: function() {
      var items = this.props.resume.publication_views.map(function(view, index) {
        var key = "pubview-" + index;
        return <PublicationViewListItem viewData={view} key={key} />;
      });

      return (
        <div className="table-responsive">
          <table className="table table-bordered table-condendsed">
            <tr>
              <th>Date</th>
              <th>IP Address</th>
              <th>Location</th>
              <th>City</th>
              <th>State</th>
              <th>Country</th>
              <th>URL</th>
              <th>Referrer</th>
              <th>User Agent</th>
            </tr>
            {items}
          </table>
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
      return (
        <tr>
          <td>{this.props.viewData.created_at}</td>
          <td>{this.props.viewData.ip_addr}</td>
          <td>{this.props.viewData.lat}, {this.props.viewData.lng}</td>
          <td>{this.props.viewData.city}</td>
          <td>{this.props.viewData.state}</td>
          <td>{this.props.viewData.country}</td>
          <td>{this.props.viewData.url}</td>
          <td>{this.props.viewData.referrer}</td>
          <td>{this.props.viewData.user_agent}</td>
        </tr>
      );
    }
  });
}(window));