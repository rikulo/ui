#Rikulo

Rikulo is a cross-platform framework for creating amazing Web and native mobile applications
in Dart and HTML 5. You can access your application directly with a modern Web browser without
any plug-in. You can also build it as a native mobile application accessing the device's resources transparently.

* [Home](http://rikulo.org)
* [Documentation](http://docs.rikulo.org)
* [API Reference](http://api.rikulo.org)
* [Discussion](http://stackoverflow.com/questions/tagged/rikulo)
* [Issues](https://github.com/rikulo/rikulo/issues)

Rikulo is distributed under an Apache 2.0 License.

##Contributors Notes

###Create Addons

Rikulo is easy to extend. The simplest way to enhance Rikulo is to open your own repository and add your own great widgets and libraries.

###Fork Rikulo

If you'd like to contribute back to the core, you can clone this repository and send us a pull request.

Please be aware that we want to keep the sphere of API as neat as possible. It might take a lot of efforts to convince us to take your code.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/articles/fork-a-repo) first.

##Development Notes

###Compile LESS to CSS

Rikulo CSS rules are written in [view.less](https://github.com/rikulo/rikulo/blob/master/resources/css/view.less). If you modify it, you have to invoke [bin/lesscss](https://github.com/rikulo/rikulo/blob/master/bin/lesscss) to generate [view.css](https://github.com/rikulo/rikulo/blob/master/resources/css/view.css) (under Linux or Cygwin bash).
