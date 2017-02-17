require_relative 'lib/es_export'
require 'zlib'
require 'aws-sdk'

filename = '/backups/output.gz'
output = Zlib::GzipWriter.open(filename)

export = EsExport::Index.new(ENV["ES_INDEX"], url: ENV["ES_URL"])

puts "Exporting #{ENV["ES_URL"]}/#{ENV["ES_INDEX"]} ..."
count = export.backup output
puts "Exported #{count} documents."

output.close

Aws.config.update({region: 'us-vault',
                   endpoint: ENV['AWS_ENDPOINT'],
                   http_read_timeout: 40,
                   retry_limit: 0,
                   ssl_verify_peer: false})
client = Aws::S3::Client.new

puts "Uploading to s3://#{ENV["S3_BUCKET"]}/#{ENV["S3_KEY"]} ..."
client.put_object acl: 'private', body: File.open(filename, 'r'), bucket: ENV["S3_BUCKET"], key: ENV["S3_KEY"]

puts "Done."
