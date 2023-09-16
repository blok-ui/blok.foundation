package ex;

import blok.foundation.core.*;
import blok.foundation.layer.*;
import blok.ui.*;
import blok.html.*;
import ex.Core;

using Breeze;
using blok.foundation.core.CoreModifiers;

class ModalExample extends Component {
  @:signal final isOpen:Bool = false;

  function render() {
    return Html.div({},
      Button.node({
        priority: Primary,
        action: _ -> isOpen.set(true),
        label: 'Open Modal'
      }),
      Show.when(isOpen, () -> Modal.node({
        onHide: () -> isOpen.set(false),
        children: [
          Html.div({
            className: Spacing.pad('bottom', 4),
          }, 'Hey world'),
          Scope.wrap(context -> Button.node({
            action: _ -> LayerContext.from(context).hide(),
            label: 'Ok'
          }))
        ]
      }))
    );
  }
}

class Modal extends Component {
  @:constant final onHide:()->Void;
  @:constant final children:Children;
  @:constant final hideOnEscape:Bool = true;

  public function render():Child {
    var target = PortalContext.from(this).target;
    return Portal.wrap(target, () -> Layer.node({
      className:  Breeze.compose(
        Flex.display(),
        Flex.alignItems('center'),
        Flex.justify('center'),
        Background.color('rgba(0,0,0,0.5)')
      ),
      hideOnEscape: hideOnEscape,
      onHide: onHide,
      child: Html.div({
        className: Breeze.compose(
          Background.color('white', 0),
          Sizing.width('250px'),
          Border.radius(2),
          Border.color('black', 0),
          Border.width(.5),
          Spacing.pad(4)
        ),
        onClick: e -> e.stopPropagation(),
        ariaModal: 'true',
        tabIndex: -1,
        role: 'dialog'
      }, ...(children:Array<Child>))
    })).lockScroll();
  }
}

