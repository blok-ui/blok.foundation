package blok.foundation.dropdown;

import blok.ui.*;

class DropdownContainer extends Component {
  @:constant final children:Children;
  
  function render() {
    return Fragment.node(...(children:Array<Child>));
  }
}
