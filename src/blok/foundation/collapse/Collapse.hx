package blok.foundation.collapse;

import blok.foundation.accordion.AccordionContext;
import blok.foundation.collapse.CollapseContext;
import blok.ui.*;

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
