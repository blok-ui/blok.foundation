package blok.foundation.dropdown;

import blok.ui.*;

/**
  Mark this component as a dropdown item. These items should be
  focusable (meaning buttons, inputs or anchor tags with an href).
  Components *must* be marked as dropdown items for the dropdown's
  keyboard controls to work with them.
**/
function asDropdownItem(child:Child) {
  return DropdownItem.node({ child: child });
}

/**
  Use this component as the dropdown's toggle. The dropdown 
  popover will be rendered relative to the toggle's dimensions
  and position. All dropdowns must have one toggle to work.
  
  Note: This modifier generally does not need to be used, as 
  the base Dropdown component will wrap its `toggle` for you.
**/
function asDropdownToggle(child:Child) {
  return DropdownToggle.node({ child: child });
}
