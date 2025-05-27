import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 2; // Default to Home
  List<int> _navigationStack = [2]; // Start with Home (index 2)

  int get selectedIndex => _selectedIndex;
  List<int> get navigationStack => _navigationStack;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    // Add the new index to the stack if it's not a pop operation
    if (_navigationStack.isEmpty || _navigationStack.last != index) {
      _navigationStack.add(index);
    }
    notifyListeners();
  }

  void popIndex() {
    // Remove the current index from the stack
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      // Set the selectedIndex to the previous index in the stack
      _selectedIndex = _navigationStack.last;
      notifyListeners();
    }
  }
}
