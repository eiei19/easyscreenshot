class S3Uploader
  AWS_SETTING = {
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region: "ap-northeast-1"
  }
  S3_DOMAIN = "easyscreenshots.s3-ap-northeast-1.amazonaws.com"
  CLOUD_FRONT_DOMAIN = "d1zmt8esqugh3r.cloudfront.net"

  attr_accessor :s3_client, :s3_resource
  def initialize
    @s3_client = Aws::S3::Client.new(AWS_SETTING)
    @s3_resource = Aws::S3::Resource.new(AWS_SETTING)
  end

  def upload filepath
    file_name = "#{Date.today.strftime("%Y%m%d")}/#{SecureRandom.hex(16)}.png"
    @s3_client.put_object(
      bucket: "easyscreenshots",
      body: File.open(filepath),
      key: file_name
    )
    @s3_resource.bucket("easyscreenshots")
      .object(file_name)
      .public_url
      .gsub(S3_DOMAIN, CLOUD_FRONT_DOMAIN)
  end
end