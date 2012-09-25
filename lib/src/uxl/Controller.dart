//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Fri, Sep 07, 2012 10:13:40 PM
// Author: tomyeh

/**
 * The controller in the MVC pattern. It is specified in the apply
 * attribute in a UXL document. For example,
 *
 *     <View apply="FooController">
 *
 * Once specified, it is assumed to be a class name. And, after the associated view
 * and all of its descendant views are instantiated, an instance of the class will
 * be instantiated and then [apply] will be called.
 *
 * ##Formats##
 *
 * There are basically four formats as shown below.
 *
 *    apply="Class"
 *    apply="name: Class"
 *    apply="#{expr}"
 *    apply="name: #{expr}"
 *
 * The first two formats specify the controller's class.
 * The last two formats specifies an expression that will return an instance
 * of the controller.
 *
 * The second and last formats specifies the variable's name that the controller
 * will be stored, such that you can retrieve it back in the following expressions.
 * On the other hand, the first and third formats won't store the controller
 * in any variable. 
 */
interface Controller<T> {
  /** Callback to initialize the views.
   * It is called after the associated view ([view]) and all of
   * its descendant views are instantiated.
   */
  void apply(T view);
}
