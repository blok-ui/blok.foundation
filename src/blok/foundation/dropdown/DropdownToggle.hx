package blok.foundation.dropdown;

import blok.ui.*;

/**
  This component is just used to mark where the dropdown toggle is.
  This is used as a target when determining where the popover
  should spawn, relative to the dimensions and position of the
  `DropdownToggle`.

  Note: This component generally does not need to be used, as 
  the base Dropdown component will wrap its `toggle` for you.
**/
class DropdownToggle extends Component {
  @:constant final child:Child;
  
  function render() {
    return child;
  }
}
