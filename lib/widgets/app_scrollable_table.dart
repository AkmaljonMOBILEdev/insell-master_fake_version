import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class ScrollableTable extends StatefulWidget {
  const ScrollableTable({super.key});

  @override
  State<ScrollableTable> createState() => _ScrollableTableState();
}

class _ScrollableTableState extends State<ScrollableTable> {
  LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();
  ScrollController _letters = LinkedScrollControllerGroup().addAndGet();
  ScrollController _numbers = LinkedScrollControllerGroup().addAndGet();

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _letters = _controllers.addAndGet();
    _numbers = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _letters.dispose();
    _numbers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              controller: _letters,
              children: <Widget>[
                _Tile('Hello A'),
                _Tile('Hello B'),
                _Tile('Hello C'),
                _Tile('Hello D'),
                _Tile('Hello E'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _numbers,
              children: <Widget>[
                _Tile('Hello 1'),
                _Tile('Hello 2'),
                _Tile('Hello 3'),
                _Tile('Hello 4'),
                _Tile('Hello 5'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.caption);

  final String caption;

  @override
  Widget build(_) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
        ),
        child: Center(
            child: Text(
          caption,
          style: const TextStyle(color: Colors.white),
        )),
      );
}
