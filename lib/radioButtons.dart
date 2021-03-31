import 'package:custom_radio/custom_radio_button.dart';
import 'package:flutter/material.dart';

class RadioButtonGrid<T> extends StatefulWidget {
  RadioButtonGrid(
      {Key? key,
      required this.values,
      T? currentVal,
      this.callback,
      required this.child,
      this.crossAxisCount = 3,
      this.crossAxisSpacing = 0.0})
      : _currentVal = ValueNotifier(currentVal),
        super(key: key);
  final List<T> values;
  final ValueNotifier<T?> _currentVal;
  final void Function()? callback;
  final Widget Function(T) child;
  final int crossAxisCount;
  final double crossAxisSpacing;

  T? get value => _currentVal.value;

  @override
  _RadioButtonGridState<T> createState() => _RadioButtonGridState<T>();
}

class _RadioButtonGridState<T> extends State<RadioButtonGrid> {
  RadioBuilder<T?, double>? simpleBuilder;
  double size = 100;

  @override
  void initState() {
    simpleBuilder = (BuildContext context, List<double> animValues,
        Function updateState, T? value) {
      final alpha = (animValues[0] * 255).toInt();
      return GestureDetector(
        onTap: () {
          setState(() {
            widget._currentVal.value = value;
          });
          if (widget.callback != null) widget.callback!();
        },
        child: Container(
/*           width: size,
          height: size, */
          margin: EdgeInsets.symmetric(vertical: 5),
          //alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor.withAlpha(alpha),
            border: Border.all(
              color: Theme.of(context).primaryColor.withAlpha(255 - alpha),
              width: 4.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: widget.child(value),
        ),
      );
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CustomRadio> widg = [];
    widget.values.forEach(
      (f) => widg.add(
        CustomRadio<T?, double>(
          value: f,
          currentGroupValue: widget.value,
          duration: Duration(milliseconds: 500),
          animsBuilder: (AnimationController? controller) =>
              [CurvedAnimation(parent: controller!, curve: Curves.easeInOut)],
          builder: simpleBuilder,
        ),
      ),
    );
    /* double width = MediaQuery.of(context).size.width;
    width -= width * 0.1;
    int n = width ~/ size; //numero max per riga
    if (n > widg.length) {
      n = widg.length;
    }
    int r = widg.length ~/ n;
    List<Row> out = [];
    for (int i = 0; i < r; i++) {
      out.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widg.getRange(i * n, i * n + n).toList(),
        ),
      );
    } */
    return GridView.count(
      crossAxisCount: widget.crossAxisCount,
      crossAxisSpacing: widget.crossAxisSpacing,
      children: widg,
    );
  }
}
