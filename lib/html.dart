//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, May 04, 2012 11:20:47 AM
// Author: tomyeh

library rikulo_html;

import "dart:html";
import "dart:math";

import "package:rikulo_commons/browser.dart" as bwr show Browser;

import "view/impl.dart" show toHexString;

part "src/html/dom_util.dart";
part "src/html/css_util.dart";
part "src/html/Points.dart";
part "src/html/Size.dart";
part "src/html/Matrix.dart";

/** A function that returns a [Point].
 */
typedef Point AsPoint();
/** A function that returns a [Point3D].
 */
typedef Point3D AsPoint3D();
/** A function that returns a [Size].
 */
typedef Size AsSize();
/** A function that returns a [Size3D].
 */
typedef Size3D AsSize3D();
/** A function that returns a [Rect].
 */
typedef Rectangle AsRectangle();
