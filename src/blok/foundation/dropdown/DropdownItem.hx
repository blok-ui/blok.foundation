package blok.foundation.dropdown;

import blok.ui.*;

/**
  This component is just a marker that indicates if something
  is an option or other item in the dropdown popover. It's required
  for the custom keyboard controls to work.

  Note that `child` should create an element that is focusable.
**/
class DropdownItem extends Component {
  @:constant final child:Child;
  
  function render() {
    return child;
  }
}
