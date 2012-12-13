//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Sep 4, 2012 12:43:16 AM
//Author: simonpai
part of rikulo_util;

/** An RGB based color object. The toString method returns a CSS-compatible color value.
 */
class Color {
  /** Construct a Color object with given RGB and alpha (i.e., opacity) values.
   * 
   * + [red], [green], [blue] should be numbers between 0 (inclusive) and 255 
   * (inclusive);
   * + [alpha] should be a number between 0 (inclusive) and 1 (inclusive).
   * Default: 1
   */
  const Color(num red, num green, num blue, [num alpha = 1]) : 
  this.red = red, this.green = green, this.blue = blue, this.alpha = alpha;
  
  /// The red component.
  final num red;
  
  /// The green component.
  final num green;
  
  /// The blue component.
  final num blue;
  
  /// The opacity of color.
  final num alpha;
  
  /// Convert to [HsvColor].
  HsvColor hsv() {
    final num mx = max(max(red, green), blue), 
        mn = min(min(red, green), blue), ch = mx - mn;
    final int lead = red > green ? 
        (red > blue ? 0 : 2) : (green > blue ? 1 : 2);
    final num hue = 60 * (ch == 0 ? 0 : 
      lead == 0 ? ((green - blue) / ch) % 6 : 
      lead == 1 ? (blue - red) / ch + 2 : (red - green) / ch + 4);
    final num val = mx * 100 / 255;
    final num sat = mx == 0 ? 0 : ch * 100 / mx;
    return new HsvColor(hue, sat, val, alpha);
  }
  
  // TODO: as utility, later
  /*
  static Color parse(String colorCode) {
    final int len = colorCode.length;
    if ((len != 7 && len != 3) || colorCode.charCodeAt(0) != 35) // #
      throw new ArgumentError(colorCode);
    
    bool short = len == 3;
    final bdr = short ? 2 : 3;
    final bdg = short ? 3 : 5;
    int r, g, b;
    
    try {
      r = parseInt("0x${colorCode.substring(1,   bdr)}");
      g = parseInt("0x${colorCode.substring(bdr, bdg)}");
      b = parseInt("0x${colorCode.substring(bdg)}");
      if (short) {
        r *= 17;
        g *= 17;
        b *= 17;
      }
    } catch (final Exception e) {
      throw new ArgumentError(colorCode);
    }
    
    return new Color(r, g, b);
  }
  */
  
  String toString() => 
      alpha == 1 ? "#${_hex(red)}${_hex(green)}${_hex(blue)}" : 
      "rgba($red, $green, $blue, $alpha)";
  
}
// helper //
String _hex(num n) => n.toInt().toRadixString(16);

/// An HSV based color object.
class HsvColor {
  
  /** Construct a Color object with given HSV and alpha (i.e., opacity) values.
   * 
   * + [hue] should be a number between 0 (inclusive) and 360 (exclusive).
   * + [saturation] and [value] should be numbers between 0 (inclusive) and 
   * 100 (inclusive).
   * + [alpha] should be a number between 0 (inclusive) and 1 (inclusive).
   * Default: 1
   */
  const HsvColor(num hue, num saturation, num value, [num alpha = 1]) : 
  this.hue = hue, this.saturation = saturation, this.value = value, this.alpha = alpha;
  
  /// The hue of the color.
  final num hue;
  
  /// The saturation of the color.
  final num saturation;
  
  /// The value of the color.
  final num value;
  
  /// The opacity of color.
  final num alpha;
  
  /// Convert to RGB based [Color].
  Color rgb() {
    final num ch = value * saturation / 10000, h2 = hue / 60, 
        x = ch * (1 - (h2 % 2 - 1).abs()), m = value / 100 - ch;
    num r = 0, g = 0, b = 0;
    if (h2 < 1) {
      r = ch; g = x;
    } else if (h2 < 2) {
      r = x; g = ch;
    } else if (h2 < 3) {
      g = ch; b = x;
    } else if (h2 < 4) {
      g = x; b = ch;
    } else if (h2 < 5) {
      b = ch; r = x;
    } else {
      b = x; r = ch;
    }
    return new Color((r + m) * 255, (g + m) * 255, (b + m) * 255, alpha);
  }
  String toString() => "hsv($hue, $saturation, $value, $alpha)";
}
