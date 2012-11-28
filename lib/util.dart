//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Feb. 04, 2012
library rikulo_util;

import "dart:html";
import "dart:math";

import "html.dart";

part "src/util/StringUtil.dart";
part "src/util/XmlUtil.dart";
part "src/util/ListUtil.dart";
part "src/util/MapUtil.dart";
part "src/util/Offset.dart";
part "src/util/Matrix.dart";
part "src/util/Color.dart";
part "src/util/Size.dart";

/** A task that is a function taking no argument and returning nothing.
 */
typedef void Task();
/** A function that returns an integer.
 */
typedef int AsInt();
/** A function that returns a double.
 */
typedef double AsDouble();
/** A function that returns a string.
 */
typedef String AsString();
/** A function that returns a bool.
 */
typedef bool AsBool();
/** A function that returns a [Offset].
 */
typedef Offset AsOffset();
/** A function that returns a [Offset3d].
 */
typedef Offset3d AsOffset3d();
/** A function that returns a [Size].
 */
typedef Size AsSize();
/** A function that returns a [Rectangle].
 */
typedef Rectangle AsRectangle();

/** A function that returns a map.
 */
typedef Map AsMap();
/** A function that returns a list.
 */
typedef List AsList();
