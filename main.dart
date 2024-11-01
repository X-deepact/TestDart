import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e, index) {
              return DockItem(
                iconData: e,
                index: index,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [IconData] items to put in this [Dock].
  final List<IconData> items;

  /// Builder building the provided [IconData] item.
  final Widget Function(IconData, int) builder;

  @override
  State<Dock> createState() => _DockState();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState extends State<Dock> {
  /// [IconData] items being manipulated.
  late List<IconData> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          return _buildDraggable(index);
        }),
      ),
    );
  }

  Widget _buildDraggable(int index) {
    return LongPressDraggable<IconData>(
      data: _items[index],
      child: DragTarget<IconData>(
        builder: (context, accepted, rejected) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 48),
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors
                  .primaries[_items[index].hashCode % Colors.primaries.length],
            ),
            child: Center(
              child: Icon(_items[index], color: Colors.white),
            ),
          );
        },
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Icon(_items[index], size: 48, color: Colors.white70),
      ),
      childWhenDragging: const SizedBox.shrink(),
    );
  }
}

/// A single dock item to display and manage state for dragging.
class DockItem extends StatelessWidget {
  final IconData iconData;
  final int index;

  const DockItem({
    required this.iconData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[index % Colors.primaries.length],
      ),
      child: Center(child: Icon(iconData, color: Colors.white)),
    );
  }
}
