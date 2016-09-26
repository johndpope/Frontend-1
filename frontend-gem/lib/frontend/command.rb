require "rest-client"
require "json"
require 'fileutils'
require 'zip'
require_relative "zip_file_generator"

module Frontend
  class Command

    def initialize(manifest_url, output_zip_file)
      @manifest_url = manifest_url
      @output_zip_file = output_zip_file
    end


    def execute
      begin
        temp_path = File.join(File.expand_path(Dir.pwd), "tmp")
        FileUtils.rm_rf(temp_path)
        FileUtils.mkdir(temp_path)
        manifest_json = self.download_manifest File.join(temp_path, "app.json")
        manifest_json["files"].each do |file|
          self.download_file(file[0], temp_path)
        end
        zip(temp_path)
      ensure
        FileUtils.rm_rf(temp_path)
      end
    end

    protected

    def zip(path)
      FileUtils.rm  @output_zip_file, :force => true
      ZipFileGenerator.new(path, @output_zip_file).write
    end

    def download_manifest(save_path)
      puts "==> Downloading manifest: #{@manifest_url}"
      manifest_json = JSON.parse(RestClient.get(@manifest_url))
      manifest_json["base_url"] = self.base_url
      File.open(save_path,"w") do |f|
        f.write(JSON.pretty_generate(manifest_json))
      end
      manifest_json
    end

    def download_file(file_path, save_path)
      puts "===> Downloading file: #{file_path}"
      url = File.join(self.base_url, file_path)
      file_folder = File.join(save_path, file_path)
      file_parent_folder =  file_folder.split("/")[0..-2].join("/")
      FileUtils.mkdir_p file_parent_folder
      File.open(file_folder, 'w') {|f|
        RestClient.get url do |str|
          f.write str
        end
      }
    end

    def base_url
      @manifest_url.split("/")[0..-2].join("/")
    end

  end
end