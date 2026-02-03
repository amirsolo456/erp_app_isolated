import 'package:flutter/material.dart';
import 'package:shared_core/index.dart';
import '../../validation/rule_mapper.dart';
import '../common/field_title.dart';

class TreeOptionField extends StatefulWidget {
  final Field field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;

  const TreeOptionField({
    Key? key,
    required this.field,
    required this.onChanged,
    required this.initialValues,
  }) : super(key: key);

  @override
  _TreeOptionFieldState createState() => _TreeOptionFieldState();
}

class _TreeOptionFieldState extends State<TreeOptionField> {
  dynamic _selectedValue;
  String _selectedLabel = '';
  String _selectedPath = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  void _initializeValue() {
    final initialValue = widget.initialValues[widget.field.name];
    if (initialValue != null) {
      _selectedValue = initialValue;

      final labelKey = '${widget.field.name}_label';
      final pathKey = '${widget.field.name}_path';

      if (widget.initialValues.containsKey(labelKey)) {
        _selectedLabel = widget.initialValues[labelKey]?.toString() ?? '';
      }

      if (widget.initialValues.containsKey(pathKey)) {
        _selectedPath = widget.initialValues[pathKey]?.toString() ?? '';
      }
    }
  }

  Future<void> _navigateToTreePage() async {
    if (widget.field.selectEndpoint == null) {
      print('❌ selectEndpoint برای فیلد ${widget.field.name} تعریف نشده است');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('آدرس سرویس تعریف نشده است')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {


      await Future.delayed(Duration(milliseconds: 500));


      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TreeSelectionPage(
            field: widget.field,
            currentSelection: _selectedValue != null
                ? {
              'value': _selectedValue,
              'label': _selectedLabel,
              'path': _selectedPath,
            }
                : null,
          ),
        ),
      );

      if (result != null && result is Map) {
        _onItemSelected(result['value'], result['label'], result['path']);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در بارگذاری داده‌های درختی'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemSelected(dynamic value, String label, String path) {
    setState(() {
      _selectedValue = value;
      _selectedLabel = label;
      _selectedPath = path;
    });


    widget.onChanged({
      'value': value,
      'label': label,
      'path': path,
    });
  }



  @override
  Widget build(BuildContext context) {
    final isRequired = RuleMapper.isRequired(widget.field.rules);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          FieldTitle(
            caption: widget.field.caption ?? '',
            help: widget.field.help,
            isRequired: isRequired,
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _isLoading ? null : _navigateToTreePage,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedValue != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedLabel.isEmpty ? 'انتخاب کنید':


                                  _selectedLabel,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            )

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}


class TreeNode {
  final dynamic id;
  final String title;
  final String? subtitle;
  final List<TreeNode> children;
  final bool isExpanded;
  final dynamic parentId;
  final int level;
  final Map<String, dynamic>? extraData;

  TreeNode({
    required this.id,
    required this.title,
    this.subtitle,
    this.children = const [],
    this.isExpanded = false,
    this.parentId,
    this.level = 0,
    this.extraData,
  });

  factory TreeNode.fromMap(Map<String, dynamic> map, {int level = 0, dynamic parentId}) {
    return TreeNode(
      id: map['id'],
      title: map['title'] ?? map['name'] ?? '',
      subtitle: map['subtitle'] ?? map['description'],
      parentId: parentId,
      level: level,
      extraData: map,
    );
  }
}


class TreeSelectionPage extends StatefulWidget {
  final Field field;
  final Map<String, dynamic>? currentSelection;

  const TreeSelectionPage({
    Key? key,
    required this.field,
    this.currentSelection,
  }) : super(key: key);

  @override
  _TreeSelectionPageState createState() => _TreeSelectionPageState();
}

class _TreeSelectionPageState extends State<TreeSelectionPage> {
  List<TreeNode> _treeData = [];
  List<TreeNode> _filteredTreeData = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTreeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTreeData() async {
    try {

      await Future.delayed(Duration(milliseconds: 800));


      final sampleData = _createSampleTreeData();


      _expandAllNodes(sampleData);

      setState(() {
        _treeData = sampleData;
        _filteredTreeData = sampleData;
        _isLoading = false;
      });

    } catch (e) {

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در بارگذاری داده‌ها')),
      );
    }
  }


  void _expandAllNodes(List<TreeNode> nodes) {
    for (var node in nodes) {

      if (node.children.isNotEmpty) {
        _expandAllNodes(node.children);
      }
    }
  }

  List<TreeNode> _createSampleTreeData() {

    return [
      TreeNode(
        id: 1,
        title: 'گروه کالا 1',
        children: [
          TreeNode(
            id: 11,
            title: 'گروه کالا 11',
            parentId: 1,
            level: 1,
            children: [
              TreeNode(
                id: 111,
                title: 'گروه کالا 111',
                parentId: 11,
                level: 2,
              ),
              TreeNode(
                id: 112,
                title: 'گروه کالا 112',
                parentId: 11,
                level: 2,
              ),
            ],
          ),
          TreeNode(
            id: 12,
            title: 'گروه کالا 12',
            parentId: 1,
            level: 1,
            children: [
              TreeNode(
                id: 121,
                title: 'گروه کالا 121',
                parentId: 12,
                level: 2,
              ),
            ],
          ),
        ],
      ),
      TreeNode(
        id: 2,
        title: 'گروه کالا 2',
        children: [
          TreeNode(
            id: 21,
            title: 'گروه کالا 21',
            parentId: 2,
            level: 1,
            children: [
              TreeNode(
                id: 211,
                title: 'گروه کالا 211',
                parentId: 21,
                level: 2,
              ),
              TreeNode(
                id: 212,
                title: 'گروه کالا 212',
                parentId: 21,
                level: 2,
              ),
            ],
          ),
          TreeNode(
            id: 22,
            title: 'گروه کالا 22',
            parentId: 2,
            level: 1,
          ),
        ],
      ),
      TreeNode(
        id: 3,
        title: 'گروه کالا 3',
        children: [
          TreeNode(
            id: 31,
            title: 'گروه کالا 31',
            parentId: 3,
            level: 1,
          ),
        ],
      ),
    ];
  }

  void _searchTree(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _filteredTreeData = _treeData;
      } else {
        _filteredTreeData = _filterNodes(_treeData, query.toLowerCase());
      }
    });
  }

  List<TreeNode> _filterNodes(List<TreeNode> nodes, String query) {
    final filtered = <TreeNode>[];

    for (var node in nodes) {
      final matches = node.title.toLowerCase().contains(query) ||
          (node.subtitle?.toLowerCase().contains(query) ?? false);

      if (matches) {
        filtered.add(node);
      }

      if (node.children.isNotEmpty) {
        final filteredChildren = _filterNodes(node.children, query);
        if (filteredChildren.isNotEmpty) {
          if (!matches) {
            filtered.add(TreeNode(
              id: node.id,
              title: node.title,
              subtitle: node.subtitle,
              children: filteredChildren,
              parentId: node.parentId,
              level: node.level,
              extraData: node.extraData,
            ));
          }
        }
      }
    }

    return filtered;
  }

  String _getNodePath(TreeNode node) {
    final pathParts = <String>[];
    _buildPath(node, _treeData, pathParts);
    return pathParts.reversed.join(' / ');
  }

  bool _buildPath(TreeNode node, List<TreeNode> nodes, List<String> pathParts) {
    for (var currentNode in nodes) {
      if (currentNode.id == node.id) {
        pathParts.add(currentNode.title);
        return true;
      }

      if (currentNode.children.isNotEmpty) {
        if (_buildPath(node, currentNode.children, pathParts)) {
          pathParts.add(currentNode.title);
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xff848484),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),

            // متن عنوان
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  widget.field.caption.toString() + ' را انتخاب کنید',
                  style: TextStyle(
                    color: Color(0xff848484),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        actions: [

          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Color(0xff848484),
            ),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadTreeData();
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: _searchQuery.isNotEmpty
                    ? Border.all(color: Colors.black, width: 1.0)
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchTree,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'جست و جو',

                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xff848484),
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: _searchQuery.isNotEmpty ? Colors.black : Colors.black87,
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredTreeData.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'داده‌ای برای نمایش وجود ندارد'
                        : 'نتیجه‌ای برای "$_searchQuery" یافت نشد',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : Directionality(
              textDirection: TextDirection.rtl,
              child: _buildCompleteTreeView(_filteredTreeData),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCompleteTreeView(List<TreeNode> nodes) {
    return ListView.builder(
      itemCount: _countAllNodes(nodes),
      itemBuilder: (context, index) {
        final node = _getNodeByIndex(nodes, index);
        if (node == null) return SizedBox();

        final isSelected = widget.currentSelection?['value'] == node.id;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),

          child: ListTile(
            contentPadding: EdgeInsets.only(
              right: 16.0 + (node.level * 24.0),
              left: 16.0,
            ),
            leading: node.children.isNotEmpty
                ? Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            )
                :


            Icon(
              Icons.horizontal_rule,
              color: Colors.grey[500],
            ),
            title:Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0XFFe6F4FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        node.title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: node.subtitle != null
                ? Text(
              node.subtitle!,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12),
            )
                : null,

            onTap: () {
              final path = _getNodePath(node);
              Navigator.pop(context, {
                'value': node.id,
                'label': node.title,
                'path': path,
                'extra': node.extraData,
              });
            },
            dense: true,
          ),
        );
      },
    );
  }


  int _countAllNodes(List<TreeNode> nodes) {
    var count = 0;
    for (var node in nodes) {
      count++; // خود گره
      if (node.children.isNotEmpty) {
        count += _countAllNodes(node.children);
      }
    }
    return count;
  }


  TreeNode? _getNodeByIndex(List<TreeNode> nodes, int index, {int currentIndex = 0}) {
    for (var node in nodes) {
      if (currentIndex == index) {
        return node;
      }
      currentIndex++;

      if (node.children.isNotEmpty) {
        final found = _getNodeByIndex(node.children, index, currentIndex: currentIndex);
        if (found != null) {
          return found;
        }
        currentIndex += _countAllNodes(node.children);
      }
    }
    return null;
  }
}