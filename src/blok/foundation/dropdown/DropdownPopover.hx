package blok.foundation.dropdown;

import blok.foundation.core.*;
import blok.ui.*;

using blok.foundation.core.CoreModifiers;

class DropdownPopover extends Component {
  @:constant final onHide:()->Void;
  @:constant final gap:Int;
  @:constant final attachment:PositionedAttachment;
  @:constant final child:Child;

  function render() {
    return Popover.node({
      getTarget: () -> findAncestorOfType(Dropdown)
        .orThrow('No Dropdown')
        .findChildOfType(DropdownToggle, true)
        .orThrow('No dropdown toggle')
        .getRealNode(),
      gap: gap,
      attachment: attachment,
      child: child
    });
  }
  
  #if (js && !nodejs)
  var current:Null<DropdownItem> = null;

  function setup() {
    var document = js.Browser.document;
    
    document.addEventListener('keydown', onKeyDown);
    document.addEventListener('click', hide);
    maybeFocusFirst();
    
    addDisposable(() -> {
      document.removeEventListener('keydown', onKeyDown);
      document.removeEventListener('click', hide);
      FocusContext.from(this).returnFocus();
    });
  }

  function hide(e:js.html.Event) {
    e.stopPropagation();
    e.preventDefault();
    onHide();
  }

  function getNextFocusedChild(offset:Int):Maybe<Component> {
    var items = filterChildrenOfType(DropdownItem, true);
    var index = Math.ceil(items.indexOf(current) + offset);
    var item = items[index];
    
    if (item != null) {
      current = item;
      return Some(current);
    }

    return None;
  }

  function maybeFocusFirst() {
    switch getNextFocusedChild(1) {
      case Some(item):
        var el:js.html.Element = item.getRealNode();
        FocusContext.from(this).focus(el);
      case None:
    }
  }

  function focusNext(e:js.html.KeyboardEvent, hideIfLast:Bool = false) {
    e.preventDefault();
    switch getNextFocusedChild(1) {
      case Some(item): 
        (item.getRealNode():js.html.Element).focus();
      case None if (hideIfLast): 
        hide(e);
      case None:
    }
  }

  function focusPrevious(e:js.html.KeyboardEvent, hideIfFirst:Bool = false) {
    e.preventDefault();
    switch getNextFocusedChild(-1) {
      case Some(item): 
        (item.getRealNode():js.html.Element).focus();
      case None if (hideIfFirst): 
        hide(e);
      case None:
    }
  }

  function onKeyDown(event:js.html.KeyboardEvent) {
    switch __status {
      case Rendering | Disposed | Disposing: return;
      default:
    }

    switch event.key {
      case 'Escape': 
        hide(event);
      case 'ArrowUp':
        focusPrevious(event);
      case 'ArrowDown':
        focusNext(event);
      case 'Tab' if (event.getModifierState('Shift')):
        focusPrevious(event, true);
      case 'Tab':
        focusNext(event, true);
      case 'Home': // ??
        maybeFocusFirst();
      default:
    }
  }
  #end
}