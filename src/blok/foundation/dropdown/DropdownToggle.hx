package blok.foundation.dropdown;

import blok.ui.*;

/**
  This is used as a target when determining where the popover
  should spawn, relative to the dimensions and position of the
  `DropdownToggle`'s real node.

  Note: This component generally does not need to be used, as 
  the base Dropdown component will wrap its `toggle` for you.
**/
class DropdownToggle extends Component {
  @:constant final child:Child;
  
  function render() {
    return child;
  }
}
