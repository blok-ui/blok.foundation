package blok.foundation.dropdown;

import blok.foundation.core.*;
import blok.foundation.dropdown.DropdownContext;
import blok.ui.*;

class Dropdown extends Component {
  @:constant final attachment:PositionedAttachment = ({ h: Middle, v: Bottom }:PositionedAttachment);
  @:constant final gap:Int = 0;
  @:constant final toggle:(context:DropdownContext)->Child;
  @:constant final child:(context:DropdownContext)->Child;
  @:constant final status:DropdownStatus = Closed;

  function render() {
    return DropdownContext.provide(() -> new DropdownContext({ 
      status: status,
      attachment: attachment,
      gap: gap
    }), dropdown -> Fragment.node(
      DropdownToggle.node({ child: toggle(dropdown) }),
      Scope.wrap(context -> switch dropdown.status() {
        case Open:
          DropdownPopover.node({
            onHide: () -> dropdown.close(),
            attachment: attachment,
            gap: gap,
            child: child(dropdown)
          });
        case Closed:
          Placeholder.node();
      })
    ));
  }
}
