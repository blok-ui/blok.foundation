package blok.foundation.dropdown;

import blok.context.Provider;
import blok.foundation.core.*;
import blok.foundation.float.*;
import blok.foundation.dropdown.DropdownContext;
import blok.ui.*;

class Dropdown extends Component {
	@:attribute final attachment:PositionedAttachment = ({h: Middle, v: Bottom} : PositionedAttachment);
	@:attribute final gap:Int = 0;
	@:attribute final toggle:(context:DropdownContext) -> Child;
	@:attribute final child:(context:DropdownContext) -> Child;
	@:attribute final status:DropdownStatus = Closed;

	function render():Child {
		return Provider
			.provide(() -> new DropdownContext(attachment, status, gap))
			.child(context -> {
				var dropdown = DropdownContext.from(context);
				Fragment.of([
					DropdownToggle.node({child: toggle(dropdown)}),
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
				]);
			});
	}
}
