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
      final Element elem = node as Element;

      //1) handle forEach, if and unless
      final Iterable forEach = loopForEach ? null: _getForEach(elem);
      if (forEach != null) {
        for (final each in forEach) {
          //TODO: setVariable("each", each)
          _create(parent, before, node, created, true);
        }
        return;
      } else if (!_isEffective(elem)) {
        return; //ignored
      }

      //2) handle special elements
      final attrs = elem.attributes;
      String name = elem.tagName.toLowerCase();
      switch (name) {
      case "attribute":
        uiFactory.setProperty(parent,
          _getAttr(attrs, "name", name), _innerHTMLOf(elem));
        return; //done
      case "variable":
        //_getAttr(attrs, "name", name);
        throw const UnsupportedOperationException("TODO");
      case "template":
        view.templates[_getAttr(attrs, "name", name)] = new Template.fromNode(node);
        return; //done
      case "pseudo":
        for (Node n in node.nodes)
          _create(parent, null, n, created);
        return; //done
      }

      //3) create a view (including pseudo)
      String s = attrs["class"];
      if (s != null)
        name = s;
      else if (name == "div")
        name = "View"; //default
      view = uiFactory.newInstance(parent, before, name);

      //4) instantiate controller
      Controller ctrl;
      if ((s = _getAttr(attrs, "apply")) != null) {
        //TODO: instantiate and assign a variable if necessary
      }

      //5) assign properties
      for (String key in attrs.getKeys()) {
        switch (key) {
          case "class": case "forEach": case "data-forEach":
          case "if": case "data-if": case "unless": case "data-unless":
          case "apply": case "data-apply":
            continue; //ignore (since they have been processed)
        }
        uiFactory.setProperty(view,
          key.startsWith("data-") ? key.substring(5): key, attrs[key]);
      }

      //6) handle the child nodes
      bool handled = false;
      if (!view.isViewGroup()) {
        bool special = false;
        for (Node n in elem.nodes) {
          if (n is Element) {
            special = _isSpecialElement((n as Element).tagName.toLowerCase());
            if (special)
              break;
          }
        }

        if (!special) { //handle it only if no special UIL element
          final text = _innerHTMLOf(node).trim();
          if (!text.isEmpty())
            uiFactory.setDefaultText(view, text);
          handled = true;
        }
      }

      if (!handled)
        for (Node n in node.nodes)
          _create(view, null, n, null);

      //7) invoke controller at the end
      if (ctrl != null)
        ctrl.apply(view);
    } else if (node is Text) {
      final text = (node as Text).wholeText.trim();
      if (!text.isEmpty())
        view = uiFactory.newText(parent, before, text);
    }

    if (created != null && view != null)
      created.add(view);
  }
  Iterable _getForEach(Element elem) => null; //TODO
  bool _isEffective(Element elem) => true; //TODO

  /** Test if the given name is a special UIL element.
   */
  static bool _isSpecialElement(String name) {
    switch (name) {
      case "pseudo": case "attribute": case "template": case "variable":
        return true;
    }
    return false;
  }
  /**
   * [requiredBy] -- if specified, it the element that requires this attribute.
   */
  static String _getAttr(Map<String, String> attrs, String name, [String requiredBy]) {
    String val = attrs[name];
    if (val == null)
      val = attrs["data-$name"];
    if (val == null && requiredBy != null)
      throw new UIException("<$requiredBy> requires the $name attribute");
    return val;
  }
  static String _innerHTMLOf(Element elem) {
    try {
      return elem.innerHTML;
    } catch (ex) { //it happens if elem is generated by DOMParser
      final StringBuffer sb = new StringBuffer();
      _getInnerHTML(sb, elem);
      return sb.toString();
    }
  }
  static void _getInnerHTML(StringBuffer sb, Element elem) {
    for (Node n in elem.nodes){
      if (n is Element) {
        final e = n as Element;
        sb.add('<').add(e.tagName);

        final attrs = e.attributes;
        for (String key in attrs.getKeys())
          sb.add(' ').add(key).add('="').add(attrs[key]).add('"');

        sb.add('>');
        _getInnerHTML(sb, e);
        sb.add('</').add(e.tagName).add('>');
      } else if (n is Text) {
        sb.add((n as Text).wholeText);
      } //ignore unrecogized such as comment and PI
    }
  }
}
