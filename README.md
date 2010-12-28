Jayson
====
A simple mac app to view JSON responses from web services.  
Based on the [JSONView](http://code.google.com/p/jsonview/) extension for Firefox/Chrome.

![Screenshot](https://github.com/YellinBen/Jayson/raw/master/jayson_screenshot1.png)

## Why ##

Since this project is based on the JSONView browser extension, you may see no need for a standalone app. I initially created Jayson because JSONView and similar browser extensions only format JSON if it detects the right content-type, which isn't always properly set. I'm now focusing on designing Jayson to fit perfectly into my web service/API workflow.

## URL Protocol ##

Jayson supports the URL protocol `jay://`
In any browser, just add this protocol to a address, like so:

		jay://http://google.com
		
And it will open in Jayson. You can create a bookmarklet to simplify the process:

		javascript:location.href='jay://'+location.href;
		
(That bookmarklet can also be installed [here](http://beenyelling.com/work/jayson/bookmarklet.html)).


## License ##

JSONView Copyright (c) 2009 Benjamin Hollis  
                                                  
This project is licensed under the MIT License.