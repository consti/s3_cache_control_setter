#
# This Utility helps you set the S3 CacheControl
#
# It's used to set CacheControl on resources that are then fetched (and cached)
# by CloudFront. Setting CacheControl will cache the resource of X seconds on
# CloudFront and on Clients (browsers), since CloudFront will forward the
# CacheControl setting to the client.
# http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Expiration.html
#
# (It's recommended to only set CacheControl and not Expires)
#
# Sidenote: To invalidate a resource on CloudFront, enable query-parameter
# forwarding and set a parameter that includes the timestamp of the object
# in the URL.
#
# You can check for HIT/MISS through curl (e.g.):
# curl -I https://xxxxxx.cloudfront.net/images/original.jpg
#
require 'aws-sdk'
class S3CacheControlSetter
  attr_reader :env
  #
  # Usage:
  #
  #   ccs = S3CacheControlSetter.new('development')
  #   ccs.set_cache_control!
  #
  # Arguments: takes the RailsEnv as an argument (to readout the s3 config)
  # You can set the @cache_control, @filter and @acl attributes.
  #
  def initialize(env = Rails.env)
    @logger = Rails.logger
    @env = env

    #
    # RegEx to filter bucket objects by key
    #
    @filter = %r{[avatars|subfolder]/\d+/.*\.[jpg|png|jpeg]}i

    #
    # How long can the client (including Cloudfront) cache the resource?
    # (In seconds)
    #
    @cache_control = "max-age=#{ 1.month.to_i }"

    #
    # Access Control List
    # http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/S3Object.html#acl%3D-instance_method
    #
    @acl = :public_read
    self
  end

  def objects
    log "Filtering objects by #{ @filter } rule"
    objects = s3_bucket.objects.select do |obj|
      obj.key =~ @filter
    end
    log "#{ objects.count } objects found"
    objects
  end

  def set_cache_control!
    objs = objects

    log "#{ objs.count } to process"
    log "settings: \n"\
         "\tacl: #{ @acl }\n"\
         "\tcache_control: #{ @cache_control }"

    objs.each_with_index do |obj, index|
      options = obj.head.merge(acl: @acl, cache_control: @cache_control)
      obj.copy_to(obj.key, options)
      log "processed: #{ index } / #{ objs.count } - key: #{ obj.key }"
    end
  end

  private

  def log(message)
    @logger.debug message
  end

  def s3_bucket
    @s3_bucket ||= begin
      log "Using settings for #{ @env } environment"
      s3_config = YAML.load_file("#{Rails.root}/config/s3.yml")[@env]

      s3 = AWS::S3.new(
        access_key_id:     s3_config['access_key_id'],
        secret_access_key: s3_config['secret_access_key']
      )
      log "Connecting to S3 Bucket #{ s3_config['bucket'] }"
      s3.buckets[s3_config['bucket']]
    end
  end
end
