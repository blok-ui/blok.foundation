package blok.foundation.collapse;

import blok.foundation.accordion.AccordionContext;
import blok.foundation.collapse.CollapseContext;
import blok.ui.*;

class Collapse extends Component {
  @:attribute final initialStatus:CollapseContextStatus = Collapsed;
  @:attribute final duration:Int = 200;
  @:children @:attribute final child:Child;

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
