//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu Feb 16 15:10:39 TST 2012
// Author: tomyeh

/**
 * A type of a data event, such as [ListDataEvent].
 */
class DataEventType {
  const DataEventType();

  /** Identifies one or more data are changed.
   */
  static final DataEventType CONTENT_CHANGED = const DataEventType();
    /** Identifies the addition of one or more contiguous items to the model.
     */
  static final DataEventType DATA_ADDED = const DataEventType();
    /** Identifies the removal of one or more contiguous items from the model.
     */   
  static final DataEventType DATA_REMOVED = const DataEventType();
  /** Identifies the structure of the lists has changed.
   */
  static final DataEventType STRUCTURE_CHANGED = const DataEventType();
  /** Identifies the selection of the lists has changed.
   * Notice that the objects being selected can be found by calling [Selection].
   */
  static final DataEventType SELECTION_CHANGED = const DataEventType();
  /** Identified the change of whether the model allows mutiple selection.
   */
  static final DataEventType MULTIPLE_CHANGED = const DataEventType();
  /** Identifies the change of the open statuses.
   * It is applicable only to [TreeModel].
   */
  static final DataEventType OPENS_CHANGED = const DataEventType();
}
