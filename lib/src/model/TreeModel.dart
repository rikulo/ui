//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Jun 11, 2012 12:37:37 PM
// Author: tomyeh

/**
 * A data model representing a tree of data.
 * Each node of the tree can be anything and represented with the generic type, `T`.
 *
 * Instead of implementing this interface from scratch, it is suggested:
 *
 * 1. Use [DefaultTreeModel] if you'd like to represent the tree with a tree of [TreeNode].
 * In other words, each node of the tree is represented with an instance of [TreeNode], and
 * the data can be retrieved by [TreeNode.data].
 * 2. Extends from [AbstractTreeModel]. [AbstractTreeModel] provides the implementation
 * of handling of data listeners, maintaining the open states and the selection.
 *
 * ##How Data Retrieved
 *
 * To retrieve the data in the data model,
 *
 * 1. [root] is called first to retrieve the root data
 * 2. [isLeaf] is called to examine if the data (aka., the node) is a leaf node
 * 3. If it is not a leaf, [getChildCount] is called to retrieve the number of children
 * 4. Then, [getChild] is called to retrieve each child
 * 5. Repeat  2-4
 *
 * ##Path
 *
 * A node of the tree model can be presented by an integer array called `path`.
 * For example, [0, 2, 1] represents a node at the third level (excluding root) since
 * there are three elements. Furthermore, it is the root's the first child's
 * the third child's second child. YOu can retrieve it as follows
 *
 *     model.getChildAt([0, 2, 1]);
 *
 * [TreeModel] doesn't not provide API to retrieve the path of a given node
 * (since sometimes it is hard to get). Thus, the view that supports [TreeModel]
 * shall store the path, if necessary, when rendering.
 *
 * On the other hand, [DefaultTreeModel] and [TreeNode] do
 * provide `getPath()` to retrieve the path of any given node.
 *
 * ##Selection
 *
 * If you'd like to use [TreeModel] with a UI object that allows the user to select the data,
 * such as [DropDownList] and [TreeView]. You have to implement `Selection<T>`.
 * Both [DefaultTreeModel] and [AbstractTreeModel] implements it, so you need to implement
 * it only if you implement [TreeModel] from scratch.
 *
 * ##Opens
 *
 * A tree model maintains a list of opened nodes ([Opens]). If a tree node matches
 * one of the open nodes, the tree node will be opened, i.e., the child views
 * will be visible to the user.
 */
interface TreeModel<T> extends DataModel {
	/**
	 * Returns the root of the tree model.
	 */
	T get root;
	/**
	 * Returns the child of the given parent at the given index where the index indicates
	 * in the parent's child array.
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 */
	T getChild(T parent, int index);
	/**
	 * Returns the number of children of the given parent.
	 *
	 * + [parent] is a node in the tree, obtained from [root] or [getChild].
	 */
	int getChildCount(T parent);
	/**
	 * Returns true if node is a leaf.
	 * In file-system terminology, a leaf node is a file, while a non-leaf node is a folder.
	 *
	 * + [node] is the data returned by [root] or [getChild].
	 */
	bool isLeaf(T node);

	/**
	 * Returns the child at the given path where the path indicates the child is
	 * placed in the whole tree.
	 *
	 * + [path] is a list of the index at each level of the tree. For example, [0, 1, 2]
	 * represents the first child's the second child's third child.
	 */
	T getChildAt(List<int> path);
}

/** A data model representing a tree of data and it allows the user to select any data of it.
 *
 * It is optional since you can implement [TreeModel] and [Selection]
 * directly. However, it is convenient that you can instantiate an instance
 * from it and access the methods in both interfaces.
 */
interface TreeSelectionModel<T> extends TreeModel<T>, Selection<T>, Disables<T>, Opens<T> {
}