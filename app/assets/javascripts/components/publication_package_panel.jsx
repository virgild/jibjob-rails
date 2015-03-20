/** @jsx React.DOM */

(function(global){
  global.JibJob.PublicationPackagePanel = React.createClass({
    propTypes: {
      pdf_url: React.PropTypes.string,
      plaintext_url: React.PropTypes.string,
      zip_url: React.PropTypes.string,
    },

    componentDidMount: function() {
    },

    render: function() {
      if (this.props.pdf_url) {
        var pdf_link = (
          <a href={this.props.pdf_url} className="">
            <span className="fa fa-file-pdf-o" />
            PDF
          </a>
        );
      }

      if (this.props.plaintext_url) {
        var plaintext_link = (
          <a href={this.props.plaintext_url} className="">
            <span className="fa fa-file-text-o" />
            Plain Text
          </a>
        );
      }

      if (this.props.zip_url) {
        var zip_link = (
          <a href={this.props.zip_url} className="">
            <span className="glyphicon glyphicon-file" />
            Zip
          </a>
        );
      }

      return (
        <div className="control-panel inactive hidden-print">
          <span className="desc">Other formats:</span>
          {pdf_link}
          {plaintext_link}
          {zip_link}
        </div>
      );
    }
  });
}(window));