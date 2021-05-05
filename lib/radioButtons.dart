import 'package:custom_radio/custom_radio_button.dart';
import 'package:flutter/material.dart';

class RadioButtonGrid<T> extends StatefulWidget {
  RadioButtonGrid(
      {Key? key,
      required this.values,
      required this.currentVal,
      this.callback,
      required this.child,
      int? crossAxisCount,
      this.crossAxisSpacing = 0.0})
      : this.crossAxisCount =
            (crossAxisCount != null ? crossAxisCount : values.length),
        super(key: key);
  final List<T> values;
  final ValueNotifier<T?> currentVal;
  final void Function()? callback;
  final Widget Function(dynamic value) child;
  final int crossAxisCount;
  final double crossAxisSpacing;

  T? get value => currentVal.value;

  @override
  _RadioButtonGridState<T> createState() => _RadioButtonGridState<T>();
}

class _RadioButtonGridState<T> extends State<RadioButtonGrid> {
  late RadioBuilder<T?, double> simpleBuilder;
  double size = 100;

  @override
  void initState() {
    simpleBuilder = (BuildContext context, List<double?> animValues,
        Function updateState, T? value) {
      final alpha = (animValues[0]! * 255).toInt();
      return GestureDetector(
        onTap: () {
          setState(() {
            widget.currentVal.value =
                widget.currentVal.value == value ? null : value;
          });
          if (widget.callback != null) widget.callback!();
        },
        child: Container(
/*           width: size,
          height: size, */
          margin: EdgeInsets.all(5),
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
          child: widget.child(value as T),
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
    double width = MediaQuery.of(context).size.width;
    width -= width * 0.1;
    int n = width ~/ size; //numero max per riga
    if (n > widget.crossAxisCount) {
      n = widget.crossAxisCount;
    }
    // num righe
    int r = widg.length ~/ widget.crossAxisCount + 1;
    if (r == 0) r = 1;
    List<Row> out = [];
    for (int i = 0; i < r; i++) {
      List<Widget> row;
      if (r != 1)
        row = widg
            .getRange(
                i * widget.crossAxisCount,
                (i * widget.crossAxisCount + widget.crossAxisCount < widg.length
                    ? i * widget.crossAxisCount + widget.crossAxisCount
                    : widg.length))
            .toList();
      else
        row = widg;
      if (row.length == widget.crossAxisCount)
        out.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row
                .map((e) =>
                    Expanded(child: AspectRatio(aspectRatio: 1, child: e)))
                .toList(),
          ),
        );
      else {
        int delta = n - row.length;
        double deltaW = width / n * delta / 2;
        List<Widget> w = List.from([
          Container(
            width: deltaW,
          )
        ]
          ..addAll(row
              .map((e) => Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: e,
                    ),
                  ))
              .toList())
          ..add(Container(
            width: deltaW,
          )));
        out.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: w),
        );
      }
    }
    return Column(
      children: out,
    );
    /* return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: widget.crossAxisCount,
      crossAxisSpacing: widget.crossAxisSpacing,
      mainAxisSpacing: widget.crossAxisSpacing,
      children: widg,
      childAspectRatio: 1,
    ); */
  }
}
