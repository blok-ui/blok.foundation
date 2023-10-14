package ex;

import blok.ui.*;
import blok.html.*;
import blok.signal.*;
import blok.foundation.collapse.*;
import ex.Core;

class CollapseExample extends Component {
  function render() {
    return Collapse.node({
      child: Panel.node({
        children: [
          ExampleCollapseHeader.node({ child: 'Collapse' }),
          ExampleCollapseBody.node({
            children: Html.p({}, 'Some stuff')
          })
        ]
      })
    });
  }
}

class ExampleCollapseHeader extends Component {
  @:attribute final child:Child;

  function render() {
    var collapse = CollapseContext.from(this);
    return Html.button({
      className: Typography.fontWeight('bold'),
      onClick: _ -> collapse.toggle(),
    },
      // `collapse.status` is a Signal, so we can observe it
      // for changes. In a real implementation, this might be
      // where you have a chevron icon rotate or otherwise
      // indicate a collapsed/expanded status.
      child,
      Text.ofSignal(new Computation(() -> switch collapse.status() {
        case Collapsed: ' +';
        case Expanded: ' -';
      }))
    );
  }
}

class ExampleCollapseBody extends Component {
  @:attribute final children:Children;

  function render() {
    return CollapseItem.node({
      child: Html.div({
        className:
          // Note: Setting overflow to 'hidden' is required for 
          // the Collapse to work properly.
          Layout.overflow('hidden')
          // Also setting box-sizing to `border-box` will make things
          // work much better, as the padding will be included in
          // when the Component calculates the size of the element.
          .with(Layout.boxSizing('border'))
      }, Html.div({
        // Note that we do NOT put the padding in the
        // main collapse target, as this will result in the collapsed
        // element still being visible even if its height is `0`.
        className: Spacing.pad('15px')
      }, ...(children:Array<Child>)))
    });
  }
}
