# Linear Objective-C

## Overview

a msgpack-rpc + α implementation for Objective-C language.

## Build Instructions
### Required tools and Dependencies
* autotools and libtool<br>
  aclocal, autoheader, automake, autoconf, libtoolize  
* XCode, clang and clang++ etc.<br>
  Download from [https://developer.apple.com](https://developer.apple.com)  
* rubygem and Cocoapods<br>
  Please refer to [http://cocoapods.org/](http://cocoapods.org/)  
* appledoc<br>
  When you want to create manuals, need to install this.  
  Please refer to [https://github.com/tomaz/appledoc](https://github.com/tomaz/appledoc)

### How to make
* Create universal library only
<pre class="fragment">
$ ./build-universal.sh
</pre>
Do after above, libraries and includes are installed into workspace/universal

* Install includes and libraries into your project

  1. Create Podfile like as follows
<pre class="fragment">
$ cd /path/to/your_project
$ cat Podfile
platform :ios, '7.0'
pod 'Linear', :git => 'https://github.com/linear-rpc/linear-objc'
</pre>
  2. Install Pods into your project
<pre class="fragment">
$ cd /path/to/your_project
$ pod install
</pre>
  3. Open project with Pods
<pre class="fragment">
$ open your_project.xcworkspace
</pre>
     Please refer to cocoapods.org for details

## Version Policy
* major<br>
  APIs and specifications are changed significantly,
  so you need to update server and client applications at the same time.
* minor<br>
  APIs are changed only slightly,
  so you need to rewrite applications if using appropriate APIs.
* revision<br>
  Bug fixes and security fixes etc.

## License
The MIT License (MIT)  
See LICENSE for details.  

And see some submodule LICENSEs(exist at deps dir).
