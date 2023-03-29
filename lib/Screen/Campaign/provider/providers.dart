import 'package:flutter/material.dart';

class ListTileColorProvider extends ChangeNotifier {
  List<int> _selectedTileIndexes = [];

  List<int> get selectedTileIndexes => _selectedTileIndexes;

  void selectTile(int index) {
    if (!_selectedTileIndexes.contains(index)) {
      _selectedTileIndexes.add(index);
      notifyListeners();
    }
  }

  void deselectTile(int index) {
    if (_selectedTileIndexes.contains(index)) {
      _selectedTileIndexes.remove(index);
      notifyListeners();
    }
  }

  void toggleTileSelection(int index) {
    if (_selectedTileIndexes.contains(index)) {
      _selectedTileIndexes.remove(index);
    } else {
      _selectedTileIndexes.add(index);
    }
    notifyListeners();
  }


}
