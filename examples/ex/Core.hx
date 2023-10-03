package ex;

import blok.ui.*;
import blok.html.*;
import blok.html.HtmlEvents;

class Panel extends Component {
  @:constant final styles:ClassName = null;
  @:constant final children:Children;
  @:constant final onClick:EventListener = null;

  function render() {
    return Html.div({
      className: Breeze.compose(
        Border.radius(2),
        Border.color('black', 0),
        Border.width(.5),
        Spacing.pad(4),
        styles
      )
    }, ...(children:Array<Child>));
  }
}

enum ButtonPriority {
  Primary;
  Normal;
}

class Button extends Component {
  @:constant final label:Child;
  @:constant final priority:ButtonPriority = Normal;
  @:constant final action:EventListener;

  function render() {
    return Html.button({
      className: Breeze.compose(
        Spacing.pad('y', 1),
        Spacing.pad('x', 3),
        Typography.fontWeight('bold'),
        Border.radius(2),
        Border.style('solid'),
        Border.width(.5),
        Border.color('black', 0),
        switch priority {
          case Primary: Background.color('sky', 200);
          case Normal: null;
        }
      ),
      onClick: action
    }, label);
  }
}
