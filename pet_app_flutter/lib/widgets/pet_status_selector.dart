import 'package:flutter/material.dart';
import 'package:pet_app/screens/adding_pet_screen.dart';

class PetStatusSelector extends StatefulWidget {
  final PetStatus selected;
  final void Function(PetStatus) onSelect;

  const PetStatusSelector({Key key, this.selected, this.onSelect}) : super(key: key);

  @override
  State<PetStatusSelector> createState() => _PetStatusSelectorState();
}

class _PetStatusSelectorState extends State<PetStatusSelector> {
  PetStatus _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PetStatus>(
      segments: const <ButtonSegment<PetStatus>>[
        ButtonSegment<PetStatus>(
          value: PetStatus.adopt,
          label: Text('Adopt'),
          icon: Icon(Icons.home),
        ),
        ButtonSegment<PetStatus>(
          value: PetStatus.lost,
          label: Text('Lost'),
          icon: Icon(Icons.close),
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
