s3_cache_control_setter
=======================

Utility that helps you set the CacheControl / Expires headers for files on S3.

Especially useful for Paperclip/Carrierwave uploads where you forgot to set the CacheControl!

### Requirements ###

```aws-sdk``` gem;

S3 AccessKey and AccessKeyID are read from a ```config/s3.yml``` based on the ```Rails.env```, but you can easily change that in L87-89.

### Usage ###

```ruby
sccs = S3CacheControlSetter.new()
# sccs.filter = %r{a_folder/*.jpg}i
# sccs.acl    = :public_read
# sccs.cache_control = "max-age=#{ 1.month.to_i }"
sccs.set_cache_control!
```

