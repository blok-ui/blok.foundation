package blok.foundation.dropdown;

import blok.context.Context;
import blok.data.Record;
import blok.debug.Debug;
import blok.foundation.core.PositionedAttachment;

enum abstract DropdownStatus(Bool) {
  final Open = true;
  final Closed = false;
}

@:fallback(error('No DropdownContext found'))
class DropdownContext extends Record implements Context {
  @:constant public final attachment:PositionedAttachment;
  @:constant public final gap:Int;
  @:signal public final status:DropdownStatus;

  public function open() {
    status.set(Open);
  }

  public function close() {
    status.set(Closed);
  }

  public function toggle() {
    status.update(status -> status == Open ? Closed : Open);
  }
}
