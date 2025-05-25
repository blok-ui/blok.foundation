package blok.foundation.dropdown;

import blok.foundation.animation.*;
import blok.foundation.core.*;
import blok.foundation.float.*;

enum abstract DropdownStatus(Bool) {
	final Open = true;
	final Closed = false;
}

class Dropdown extends Component {
	/**
		Animation to run when the Dropdown popover is shown.
	**/
	@:attribute final showAnimation:Keyframes = null;

	/**
		Animation to run when the Dropdown popover is hidden.
	**/
	@:attribute final hideAnimation:Keyframes = null;

	/**
		Speed of the show/hide animations.
	**/
	@:attribute final transitionSpeed:Int = null;

	/**
		How the dropdown popover should be attached when it is shown. This will
		be relative to the child returned by `toggle`.
	**/
	@:attribute final attachment:PositionedAttachment = ({h: Middle, v: Bottom} : PositionedAttachment);

	/**
		The gap between the toggle and the dropdown popover.
	**/
	@:attribute final gap:Int = 0;

	/**
		A function to create the toggle that will control the visibility of the Dropdown.
		The `toggle` argument is a function that can be used to open the dropdown popover.

		Here's a simple example:

		```haxe
		Dropdown.node({
			// other arguments omitted
			toggle: toggle -> Html.button({
				onClick: _ -> toggle()
			}).child('Show Dropdown')
		});
		```
	**/
	@:attribute final toggle:(toggle:() -> Void)->Child;

	/**
		The child that will be shown in the dropdown's popover.
	**/
	@:attribute final child:Child;

	/**
		The initial status of the dropdown popover (defaults to `Closed`).
	**/
	@:signal final status:DropdownStatus = Closed;

	public function render():Child {
		var toggleNode = toggle(() -> if (status.peek() == Closed) status.set(Open));

		return Provider
			.provide(FocusContext.from(this))
			.child(Fragment.of([
				toggleNode,
				Scope.wrap(context -> switch status() {
					case Open:
						Popover.node({
							showAnimation: showAnimation,
							hideAnimation: hideAnimation,
							hideOnEscape: false,
							transitionSpeed: transitionSpeed,
							onHide: () -> status.set(Closed),
							attachment: attachment,
							gap: gap,
							getTarget: () -> investigate()
								.findChild(view -> view.currentNode() == toggleNode, true)
								.map(view -> view.firstPrimitive())
								.orThrow('Could not resolve the Dropdown toggle'),
							child: DropdownContainer.node({
								child: child
							})
						});
					case Closed:
						Placeholder.node();
				})
			]));
	}
}
