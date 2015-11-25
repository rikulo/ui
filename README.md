#Rikulo UI

[Rikulo UI](http://rikulo.org/projects/ui) is a cross-platform framework for creating amazing Web and native mobile applications in Dart and HTML 5. Our aim is to bring structure to your user interface with a strong layout system, recursive component composition, and neat libraries.

You can access your application directly with a modern Web browser without any plug-in. You can also build it as a native mobile application accessing the device's resources transparently.

* [Home](http://rikulo.org/projects/ui)
* [Documentation](http://docs.rikulo.org/ui/latest)
* [API Reference](http://www.dartdocs.org/documentation/rikulo_ui/0.8.0)
* [Discussion](http://stackoverflow.com/questions/tagged/rikulo)
* [Source Code Repos](https://github.com/rikulo/ui)
* [Issues](https://github.com/rikulo/ui/issues)

Rikulo is distributed under an Apache 2.0 License.

[![Build Status](https://drone.io/github.com/rikulo/ui/status.png)](https://drone.io/github.com/rikulo/ui/latest)

##Installation

Add this to your `pubspec.yaml` (or create it):

    dependencies:
      rikulo_ui:

Then run the [Pub Package Manager](http://pub.dartlang.org/doc) (comes with the Dart SDK):

    pub install

For more information, please refer to [Rikulo: Getting Started](http://docs.rikulo.org/ui/latest/Getting_Started/) and [Pub: Getting Started](http://pub.dartlang.org/doc).

##Usage

Creating UI in Rikulo is straightforward.

    import 'package:rikulo_ui/view.dart';

    void main() {
      new TextView("Hello World!") //create UI
        .addToDocument(); //make it available to the browser
    }

For more information, please refer to [the Hello World sample application](http://docs.rikulo.org/ui/latest/Getting_Started/Hello_World.html).

##Notes to Contributors

###Create Addons

Rikulo is easy to extend. The simplest way to enhance Rikulo is to [create a new repository](https://help.github.com/articles/create-a-repo) and add your own great widgets and libraries to it.

###Fork Rikulo

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

Please be aware that one of Rikulo's design goals is to keep the sphere of API as neat and consistency as possible. Strong enhancement always demands greater consensus.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.

##Development Notes

###Compile LESS to CSS

Rikulo CSS rules are placed in [view.less](https://github.com/rikulo/ui/blob/master/lib/css/default/view.less). They are written in [LESS](http://lesscss.org/). If you modify [view.less](https://github.com/rikulo/ui/blob/master/lib/css/default/view.less), you have to invoke [tool/l2c](https://github.com/rikulo/ui/blob/master/tool/l2c) to generate [view.css](https://github.com/rikulo/ui/blob/master/lib/css/default/view.css) (under Linux or Cygwin bash).
