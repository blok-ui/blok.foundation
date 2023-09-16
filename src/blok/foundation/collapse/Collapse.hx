package blok.foundation.collapse;

import blok.ui.*;
import blok.foundation.collapse.CollapseContext;
import blok.foundation.accordion.AccordionContext;

class Collapse extends Component {
  @:constant final child:Child;
  @:constant final initialStatus:CollapseContextStatus = Collapsed;
  @:constant final duration:Int = 200;

  function render() {
    return CollapseContext.provide(
      () -> new CollapseContext(
        initialStatus,
        duration,
        AccordionContext.maybeFrom(this).unwrap()
      ),
      _ -> child
    );
  }
}
