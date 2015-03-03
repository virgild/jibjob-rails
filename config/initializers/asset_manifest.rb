# Data from the gulped manifest file
class AssetManifest
  def self.manifest
    @manifest || if File.exists?(Rails.root.join('manifest.json'))
      @manifest ||= JSON.parse(File.read(Rails.root.join('manifest.json')))
    end
  end

  def self.assets_root
    "/assets"
  end

  def self.stylesheet_path(url)
    if url.starts_with?('/')
      return url
    end

    if AssetManifest.manifest
      url = "#{url}.css" unless url.ends_with?('.css')
      url = "/css/#{url}" unless url.starts_with?('/css')
      "#{assets_root}#{AssetManifest.manifest[url]}" || url
    else
      "#{assets_root}/css/#{url}"
    end
  end

  def self.javascript_path(url)
    if url.starts_with?('/')
      return url
    end

    if AssetManifest.manifest
      url = "#{url}.js" unless url.ends_with?('.js')
      url = "/js/#{url}" unless url.starts_with?('/js')
      "#{assets_root}#{AssetManifest.manifest[url]}" || url
    else
      "#{assets_root}/js/#{url}"
    end
  end

  def self.asset_path(url)
    if AssetManifest.manifest
      "#{assets_root}#{AssetManifest.manifest[url]}" || url
    else
      "#{assets_root}#{url}"
    end
  end
end