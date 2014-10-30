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

### License ###

The MIT License (MIT)

Copyright (c) 2014 Constantin Hofstetter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
