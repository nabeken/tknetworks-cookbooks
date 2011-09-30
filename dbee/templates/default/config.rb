# vim:fileencoding=utf-8
# vim:filetype=ruby

module DBEE
  module Config
    RAKE = "<%= @rake %>"
    API_URL = "<%= @api_url %>"
    MATERIAL_BASE_URL = "<%= @material_base_url %>"
    REQUEST_REDIS_HKEY = "request"
    #MATERIAL_DIR = "/srv/storage/recordings"
    #DAV_DIR = "/srv/dav"
    HTTP_USER = "<%= @http_user %>"
    HTTP_PASSWORD = "<%= @http_password %>"
    CA_DIR = "<%= @ca_dir %>"

    module Encode
      PRESET   = File.expand_path(File.dirname(__FILE__) + '/sample/libx264-iPad.ffpreset')
      PROGRAM_ID = {
        /ＭＸテレビ/   => "23608",
        /ＴＢＳテレビ/ => "1048",
        /フジテレビ/   => "1056",
        /日本テレビ/   => "1040",
        /ＮＨＫ教育/   => "1032",
        /ＮＨＫ総合/   => "1024",
        /テレビ東京/   => "1072",
        /テレビ朝日/   => "1064"
      }
      OUTPUT_DIR = "<%= @output_dir %>"
    end

    module Upload
      AMAZON_ACCESS_KEY_ID = ENV['AMAZON_ACCESS_KEY_ID'] || 'your access key'
      AMAZON_SECRET_ACCESS_KEY = ENV['AMAZON_SECRET_ACCESS_KEY'] || 'your secret key'
      UPLOAD_BUCKET = 'dbee'
      DAV_STORAGE_BASE_URL = "<%= @dav_baseurl %>"
    end
  end
end
