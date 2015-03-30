require 'render_anywhere'

class ResumeRenderer
  include RenderAnywhere
  include PdfHelper

  def initialize(resume)
    @resume = resume
  end

  def render_theme(theme, opts={})
    unless rendering_controller.lookup_context.template_exists?("resume_renderer/themes/#{theme}")
      theme = 'default'
    end
    layout = opts.delete(:layout)

    render_opts = {
      template: "resume_renderer/themes/#{theme}",
      locals: { resume: @resume },
      disable_external_links: true,
      disable_internal_links: true,
      print_media_type: true,
      outline: { outline: true },
      layout: "resume_renderer/#{layout}"
    }

    render(render_opts)
  end
end