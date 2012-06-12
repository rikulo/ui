//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:37:37 PM
// Author: tomyeh

/** The listener for [TreeDataEvent]
 */
typedef void TreeDataListener(TreeDataEvent event);

/**
 * A data model representing a tree of data.
 * Each node of the tree can be anything and represented with the generic type, `E`.
 *
 * Instead of implementing this interface from scratch, it is suggested:
 
 * 1. Use [DefaultTreeModel] if you'd like to represent the tree with a tree of [TreeNode].
 * In other words, each node of the tree is represented with an instance of [TreeNode], and
 * the data can be retrieved by [TreeNode.data].
 * 2. Extends from [AbstractTreeModel]. [AbstractTreeModel] provides the implementation
 * of handling of data listeners, maintaining the open states and the selection.
 *
 * ##How Data Retrieved##
 *
 * To retrieve the data in the data model,
 *
 * 1. [root] is called first to retrieve the root data
 * 2. [isLeaf] is called to examine if the data (aka., the node) is a leaf node
 * 3. If it is not a leaf, [getChildCount] is called to retrieve the number of children
 * 4. Then, [getChild] is called to retrieve each child
 * 5. Repeat  2-4
 *
 * ##Path##
 *
 * A node of the tree model can be presented by an integer array called `path`.
 * For example, [0, 1, 2] represents a node at the third level since
 * there are three elements. Furthermore, it is the root's the first child's
 * the second child's third child.
 *
 * ##Open Paths##
 *
 * A tree model maintains a list of open paths. If the path of a tree node matches
 * one of the open paths, the tree node will be opened, i.e., the child views
 * will be visible to the user.
 *
 * ##Selection##
 *
 * If you'd like to use [TreeModel] with a UI object that allows the user to select the data,
 * such as [SelectView] and [TreeView]. You have to implement `Selection<E>`.
 * Both [DefaultTreeModel] and [AbstractTreeModel] implements it, so you need to implement
 * it only if you implement [TreeModel] from scratch.
 */
interface TreeModel<E> {
	/**
	 * Returns the root of the tree model.
	 */
	E get root();
	/**
	 * Returns the child of the given parent at the given index where the index indicates
	 * in the parent's child array.
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 */
	E getChild(E parent, int index);
	/**
	 * Returns the number of children of the given parent.
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 */
	int getChildCount(E parent);
	/**
	 * Returns true if node is a leaf.
	 * In file-system terminology, a leaf node is a file, while a non-leaf node is a folder.
	 *
	 * + [node] is the data returned by [root] or [getChild].
	 */
	bool isLeaf(E node);

	/**
	 * Returns the index of the given child in the given parent.
	 * If either parent or child is null, returns -1.
	 * If either parent or child don't belong to this tree model, returns -1. 
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 * + [child] the node we are interested in 
	 */
	int getIndexOfChild(E parent, E child);
	/**
	 * Returns the child at the given path where the path indicates the child is
	 * placed in the whole tree.
	 *
	 * + [path] is a list of the index at each level of the tree. For example, [0, 1, 2]
	 * represents the first child's the second child's third child.
	 */
	E getChildAt(List<int> path);
	/**
	 * Returns the path from the given child, where the path indicates the child is
	 * placed in the whole tree.
	 */
	List<int> getPath(E child);

  /**
   * Returns the current list of nodes that are opened.
   * It is readonly. Don't modify it directly. Otherwise, UI won't be
   * updated correctly.
   */
  Set<E> get opens();
  /**
   * Replace the current list of node that are opened with the given set.
   */
  void set opens(Collection<E> opens);
  /** Adds the given node to the list of open nodes.
   */
  bool addToOpens(E node);
  /** Removes the given node from the list of open nodes.
   */
  bool removeFromOpens(E node);
  /** Returns true if the node shall be opened.
   * That is, it tests if the given node is in the list of open nodes.
   */
  bool isOpened(E node);
  /** Returns true if the list of open nodes is empty.
   */
  bool isOpensEmpty();
  /** Empties the list of open nodes.
   */
  void clearOpens();

	/**
	 * Add a listener to the tree that's notified each time a change to the data model occurs
	 */
	void addTreeDataListener(TreeDataListener l);
	/**
	 * Remove a listener to the tree that's notified each time a change to the data model occurs
	 */
	void removeTreeDataListener(TreeDataListener l);
}

/** A data model representing a tree of data and it allows the user to select any data of it.
 *
 * It is optional since you can implement [TreeModel] and [Selection]
 * directly. However, it is convenient that you can instantiate an instance
 * from it and access the methods in both interfaces.
 */
interface TreeSelectionModel<E> extends TreeModel<E>, Selection<E> {
}