require "thor"
require "frontend/version"
require_relative "frontend/command"

class FrontendCLI < Thor

  desc "download MANIFEST_URL ZIP_PATH", "download the frontend specified in the MANIFEST_URL and compress it into a zip in ZIP_PATH"
  def download(manifest_url, zip_path)
    Frontend::Command.new(manifest_url, zip_path).execute
  end

end

FrontendCLI.start(ARGV)