module AssetManifestHelpers
  extend ActiveSupport::Concern

  def stylesheet_link_tag(url, options={})
    url = AssetManifest.stylesheet_path(url)
    super(url, options)
  end

  def crossorigin_javascript_include_tag(url, options={})
    url = AssetManifest.javascript_path(url)
    super(url, options)
  end

  def javascript_include_tag(url, options={})
    url = AssetManifest.javascript_path(url)
    super(url, options)
  end

  def image_tag(url, options={})
    if !url.starts_with?('/images/')
      url = "/images/#{url}"
    end
    url = AssetManifest.asset_path(url)
    super(url, options)
  end

  def image_path(url, options={})
    if !url.starts_with?('/images/')
      url = "/images/#{url}"
    end
    url = AssetManifest.asset_path(url)
    super(url, options)
  end

  def image_url(url, options={})
    if !url.starts_with?('/images/')
      url = "/images/#{url}"
    end
    url = AssetManifest.asset_path(url)
    super(url, options)
  end
end