//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Jan. 09, 2012
#library("artra:widget:Block");

#import("Div.dart");
#import("IdSpace.dart");

/** A Div that is also an ID space.
 */
class Block extends Div implements IdSpace {
  Block() {
  	wclass = "w-block";
  }
}
