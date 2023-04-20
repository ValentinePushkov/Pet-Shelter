import 'package:flutter/material.dart';
import 'package:pet_app/screens/adding_pet_screen.dart';

class SexSelector extends StatefulWidget {
  final Gender selected;
  final void Function(Gender) onSelect;

  const SexSelector({Key key, this.selected, this.onSelect}) : super(key: key);

  @override
  State<SexSelector> createState() => _SexSelectorState();
}

class _SexSelectorState extends State<SexSelector> {
  Gender _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Gender>(
      segments: const <ButtonSegment<Gender>>[
        ButtonSegment<Gender>(
          value: Gender.female,
          label: Text('Female'),
          icon: Icon(Icons.woman),
        ),
        ButtonSegment<Gender>(
          value: Gender.male,
          label: Text('Male'),
          icon: Icon(Icons.man),
        ),
      ],
      selected: {_selected},
      onSelectionChanged: (value) {
        setState(() {
          _selected = value.first;
          widget.onSelect(value.first);
        });
      },
    );
  }
}
