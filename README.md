# nmss-luminate

THIS IS NO LONGER IN USE. IT HAS BEEN MIGRATED OVER TO https://github.com/NationalMSSociety/nmss-luminate.
PLEASE USE THIS REPO FOR VERSION CONTROL AND ALL UPDATES GOING FORWARD. THIS IS FOR ARCHIVE PURPOSES ONLY.

Using Grunt and local development
---------------------------------

Before getting started using Grunt, you'll need to install [Node.js version 6.14.4](https://nodejs.org/en/blog/release/v6.14.4/). Once you have Node installed, you'll need to install the project
dependencies:

```
npm install
```

If you are on a Mac and do not have root administrator permissions, you may need to use sudo:

```
sudo npm install
```

With the dependencies installed, you can run the default dev tasks:

```
grunt
```


Debug Mode
----------

By default, Luminate Online will load the minified versions of assets such as stylesheets and JavaScript files. To force a page to load unminified assets,
set the debug session variable to "true" using the s_debug GET parameter:

```
&s_debug=true
```

Proxy tools
-----------

When developing locally, you can use an HTTP proxy tool to reroute requests to the nmss-framework directory on the Luminate Online filesystem to your
machine. For Mac you can use [Charles](https://www.charlesproxy.com/), in Windows you can use [Fiddler](https:ws//www.telerik.com/fiddler). With the Fiddler extension, you can add Auto Response rules to replace the String
"https://secure3.convio.net/nmssdev/nmss-framework/" with the Path "http://localhost:8000/". It should be noted that you can intercept JavaScript and CSS files with a proxy tool, to test HTML updates you will need to upload files to your branch.

You should always use debug mode when developing locally.
