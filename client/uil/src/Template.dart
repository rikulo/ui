//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Sep 06, 2012  3:34:34 PM
// Author: tomyeh

/**
 * The template representing a UIL document.
 */
class Template {
  final List<Node> _nodes;

  /** Instantiate a template from a string, which must be a valid XML document.
   *
   * Examples:
   * 
   *     new Template('''
   *        <View layout="type: linear">
   *          UIL: <Switch value="true">
   *        </View>
   *        ''');
   */
  factory Template(String xml)
  => new Template.fromNode(
      new DOMParser().parseFromString(xml, "text/xml").documentElement);
  /** Instantiated from a fragment of a DOM tree.
   *
   * Examples:
   * 
   * HTML:
   *
   *     <div class="View" data-layout="type: linear">
   *       UIL: <div class="Switch" data-value="true"></div>
   *     </div>
   *
   * Java:
   *
   *     new Tempalte.fromNode(document.query("#templ").elements[0].remove());
   *
   * Notice that it is OK to use the XML format as described in [Template] constructor,
   * though it is not a valid HTML document.
   */
  Template.fromNode(Node node): _nodes = [node];
  Template.fromNodes(List<Node> nodes): _nodes = nodes;

  /** Creates and returns the views based this template.
   *
   * + [parent] the parent. If null, the created view(s) won't have parent; nor attached.
   * + [before] the child of the parent that new views will be inserted before.
   * Ignored if null.
   */
  List<View> create([View parent, View before]) { //TODO: VariableResolver when rikulo-el ready
    final List<View> created = [];
    for (Node node in _nodes)
      _create(parent, before, node, created);
    return created;
  }
  void _create(View parent, View before, Node node, List<View> created,
  [bool loopForEach=false]) {
    View view;
    if (node is Element) {
      final Element el = node as Element;

      //1) handle forEach, if and unless
      final Iterable forEach = loopForEach ? null: _getForEach(el);
      if (forEach != null) {
        for (final each in forEach) {
          //TODO: setVariable("each", each)
          _create(parent, before, node, created, true);
        }
        return;
      } else if (!_isEffective(el)) {
        return; //ignored
      }

      //2) handle special elements
      String name = el.tagName.toLowerCase();
      switch (name) {
      case "attribute":
      case "template":
      case "variable":
        throw const UnsupportedOperationException("TODO");
      case "pseudo":
        for (Node n in node.nodes)
          _create(parent, null, n, created);
        return;
      }

      //3) create a view (including pseudo)
      final attrs = el.attributes;
      String s = attrs["class"];
      if (s != null)
        name = s;
      else if (name == "div")
        name = "View"; //default
      view = uiFactory.newInstance(parent, before, name);

      //4) assign properties
      for (String key in attrs.getKeys()) {
        switch (key) {
          case "class":
          case "forEach":
          case "data-forEach":
          case "if":
          case "data-if":
          case "unless":
          case "data-unless":
            continue; //ignore (since they have been processed)
          case "apply":
          case "data-apply":
            //TODO
            continue;
        }
        uiFactory.setProperty(view,
          key.startsWith("data-") ? key.substring(5): key, attrs[key]);
      }

      //5) handle the child nodes
      for (Node n in node.nodes)
        _create(view, null, n, null);

    } else if (node is Text) {
      String text = (node as Text).wholeText.trim();
      if (!text.isEmpty())
        view = uiFactory.newText(parent, before, text);
    }

    if (created != null && view != null)
      created.add(view);
  }
  Iterable _getForEach(Element el) => null; //TODO
  bool _isEffective(Element el) => true; //TODO
}
