package blok.foundation.dropdown;

import blok.ui.*;

/**
  This component is just a marker that indicates if something
  is an option or other item in the dropdown popover. It's required
  for the custom keyboard controls to work, but note that 
  child components should create focusable real nodes (for example,
  `Html.a(...)` will work, as will `Html.button({...})` or `Html.input({...})`).
**/
class DropdownItem extends Component {
  @:constant final child:Child;
  
  function render() {
    return child;
  }
}
