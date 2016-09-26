require "spec_helper"
require 'webmock/rspec'
require 'zip'
require 'json'

describe "Command" do

  before :each do
    @tmp_folder = File.join File.expand_path(Dir.pwd), "tmp"
    @manifest_url = "https://test.com/manifest.json"
    @download_path = File.join File.expand_path(Dir.pwd), "frontend.zip"
    @subject = Frontend::Command.new(@manifest_url, @download_path)
    @manifest_json = {files:
      {
          "a/file.txt": "2222",
          "b/file.txt": "44444"
      }
    }
    stub_request(:get, @manifest_url).to_return(body: @manifest_json.to_json)
    stub_request(:get, "https://test.com/a/file.txt").to_return(body: "test1")
    stub_request(:get, "https://test.com/b/file.txt").to_return(body: "test2")
  end

  describe "frontend download" do
    before :each do
      @subject.execute
      FileUtils.rm_rf @tmp_folder
      FileUtils.mkdir @tmp_folder
      Zip::File.open(@download_path) do |zip_file|
        zip_file.each do |entry|
          f_path=File.join(@tmp_folder, entry.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          entry.extract(f_path) unless File.exist?(f_path)
        end
      end
    end

    after :each do
      FileUtils.rm_rf @download_path
      FileUtils.rm_rf @tmp_folder
    end

    it "should zip the file" do
      expect(File.exist?(@download_path)).to be_truthy
    end

    describe "manifest" do
      it "should include the base_url" do
        manifest_path = File.join @tmp_folder, "app.json"
        manifest = JSON.parse(File.read(manifest_path))
        expect(manifest["base_url"]).to eq("https://test.com")
      end

      it "should contain all the files" do
        manifest_path = File.join @tmp_folder, "app.json"
        manifest = JSON.parse(File.read(manifest_path))
        expect(manifest["files"].count).to eq(2)
      end
    end

    describe "files" do
      it "should contain the files in the correct folders" do
        a_file = File.read(File.join(@tmp_folder, "a/file.txt"))
        b_file = File.read(File.join @tmp_folder, "b/file.txt")
        expect(a_file).to eq("test1\n")
        expect(b_file).to eq("test2\n")
      end
    end
  end

end
