import 'package:flutter/material.dart';
import 'package:zoom_menu/zoom_scaffold.dart';

class MenuScreen extends StatefulWidget {

  final MenuController menuController;
  final Menu menu;
  final String selectedMenuItemId;
  final Function(String) onMenuItemSelected;

  MenuScreen({
    this.menuController,
    this.menu,
    this.selectedMenuItemId,
    this.onMenuItemSelected,
  });

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  MenuController menuController;

  @override
  void initState() {
    super.initState();
    menuController = widget.menuController
      ..addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  _createMenuTitle() {
    final titleTranslation = 250.0 * (1.0 - menuController.percentOpen) - 100.0;

    return new Transform(
      transform: new Matrix4.translationValues(
          titleTranslation,
          0.0,
          0.0
      ),
      child: new OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: new Padding(
          padding: const EdgeInsets.all(30.0),
          child: new Text(
            'Menu',
            style: new TextStyle(
              color: const Color(0x88444444),
              fontSize: 240.0,
              fontFamily: 'mermaid',
            ),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  _createMenuList(MenuController menuController) {
    final listItemWidgets = widget.menu.items.map((MenuItem item) {
      return new _MenuListItem(
        title: item.title,
        isSelected: item.id == widget.selectedMenuItemId,
        onTap: () {
          menuController.close();
          widget.onMenuItemSelected(item.id);
        }
      );
    }).toList();

    return new Column(
      children: listItemWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController) {
        return new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/dark_grunge_bk.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new Material(
            color: Colors.transparent,
            child: new Stack(
              children: [
                _createMenuTitle(),

                new Transform(
                  transform: new Matrix4.translationValues(0.0, 225.0, 0.0),
                  child: _createMenuList(menuController),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuListItem extends StatelessWidget {

  final String title;
  final bool isSelected;
  final Function() onTap;

  _MenuListItem({
    this.title,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: new Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: new Text(
            title,
            style: new TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontSize: 25.0,
              fontFamily: 'bebas-neue',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  Menu({
    this.items,
  });
}

class MenuItem {
  final String id;
  final String title;

  MenuItem({
    this.id,
    this.title,
  });
}