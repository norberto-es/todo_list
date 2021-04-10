import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimeComponent extends StatefulWidget {
  DateTime date;
  ValueChanged<DateTime> onSelectedTime;

  TimeComponent({
    Key key,
    this.date,
    this.onSelectedTime,
  }) : super(key: key);

  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  final List<String> _hours = List.generate(24, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _min = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _sec = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  String _hourSelected = '00';
  String _minSelected = '00';
  String _secSelected = '00';

  void invokeCallback() {
    var newDate = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      int.parse(_hourSelected),
      int.parse(_minSelected),
      int.parse(_secSelected),
    );
    widget.onSelectedTime(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBox(_hours, (String value) {
          setState(() {
            _hourSelected = value;
            invokeCallback();
          });
        }),
        _buildBox(_min, (String value) {
          setState(() {
            _minSelected = value;
            invokeCallback();
          });
        }),
        _buildBox(_sec, (String value) {
          setState(() {
            _secSelected = value;
            invokeCallback();
          });
        }),
      ],
    );
  }

  Widget _buildBox(List<String> options, ValueChanged<String> onChanged) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            color: Theme.of(context).primaryColor,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: ListWheelScrollView(
        onSelectedItemChanged: (value) =>
            onChanged(value.toString().padLeft(2, '0')),
        itemExtent: 60,
        perspective: 0.007,
        physics: FixedExtentScrollPhysics(),
        children: options
            .map<Text>((e) => Text(
                  e,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white),
                ))
            .toList(),
      ),
    );
  }
}
