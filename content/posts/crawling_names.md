+++
date = "2016-06-02T21:49:10+01:00"
draft = false
description = "Crawling Persian names website"
keywords = ["crawling", "flask", "ایرانی", "نام ایرانی" , "persian names"]
title = "Persian names"
type = "post"
+++

##### Intro
I'm gonna be a daddy in 3 weeks, and we're still thinking about the names.
The Persian names that are allowed by Iran government (yes, you cannot give
any name you want), is listed in https://www.sabteahval.ir/ website. The
UX of that website is really awful, so I decided to crawl the website and
just go through the names in an easier way.

##### Crawling and Storing in window.localStorage
The website is generating the whole page for each listing of names, and
it uses the app session parameter to keep its state, so it's a bit of work
to use anything other than the browser to crawl the pages. So I decided to
write a javascript code and run it under the website using this chrome
extension: [Custom JavaScript for websites](https://chrome.google.com/webstore/detail/custom-javascript-for-web/poakhlngfciodnhlhhgnaaelnpjljija)
The script tries to save all names in `window.localStorage`, it gets
stuck in some cases (the website is sometimes very slow), but I managed
to go through all the names with a few restarts.

[Link](name-crawler.js)


##### Transferring window.localStorage to a File

Now, all the names are under the `window.localStorage`, but how to move them
into a more suitable place for searching? I thought just running
`json.stringify(window.localStorage)` should do the job, but seems the
amount of data in `window.localStorage` is a too big bite for the browser.
It took more than 5 minutes and I was still waiting for 6000+ names to be printed
in the console. So it did not seem to work.

So, plan B, I threw a simple Python flask app to be able to post all the names from
javascript in there and store them as a file. Here's the flask app:
[dumper python app](dumper.py).
The app also cleans up and removes duplicates from the names.

And this is how I could send the names from javascript console to the python app,
listening on port 5000:
```
$.ajaxSetup({
  contentType: "application/json; charset=utf-8"
});
for (var key in window.localStorage) {$.post("https://localhost:5000", window.localStorage[key], "json");}
```

But, oops again, javascript console was spilling a lot of INSUFFICIENT_RESOURCES
errors:
```
POST https://localhost:5000/ net::ERR_INSUFFICIENT_RESOURCES
```
Probably because of too many `POST`s sent all together to the web server. To work
around it, I tried the following:
```
for (var key in window.localStorage) {
  window.setTimeout(
    function(k){
      return function() {
        $.post("https://localhost:5000", window.localStorage[k], "json");
      };
    }(key),
    Math.random() * 40000);}
```
It distributes the `POST`s in a range of 40 seconds, and this trick stopped the
errors. Now I've got the full list of names, cleaned up and sorted:
[Full list of names](dump.json)


##### Viewing
For viewing, I just loaded everything in a simple AngularJS page. You can see the final
results here: [Names](names.html)
