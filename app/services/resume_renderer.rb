require 'render_anywhere'

class ResumeRenderer
  include RenderAnywhere
  include PdfHelper

  def initialize(resume)
    @resume = resume
  end

  def render_theme(theme, opts={})
    with_layout = opts.delete(:with_layout)
    render_opts = {
      template: "resume_renderer/themes/#{theme}",
      locals: { resume: @resume },
      disable_external_links: true,
      disable_internal_links: true,
      print_media_type: true,
      outline: { outline: true }
    }

    if with_layout
      render_opts[:layout] = "resume_renderer/layout"
    else
      render_opts[:layout] = nil
    end

    render(render_opts)
  end
end