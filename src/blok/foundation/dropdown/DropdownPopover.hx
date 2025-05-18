package blok.foundation.dropdown;

import blok.engine.ComposableView;
import blok.foundation.float.*;
import blok.foundation.core.*;
import blok.*;

/**
	This is the popover that is rendered when the Dropdown is 
	activated. It will be displayed relative to the closest 
	DropdownToggle based on the provided `gap` and `attachment`.
**/
class DropdownPopover extends Component {
	@:attribute final onHide:() -> Void;
	@:attribute final gap:Int;
	@:attribute final attachment:PositionedAttachment;
	@:children @:attribute final child:Child;

	function render() {
		return Popover.node({
			// @todo: This has always been awkward, and now it's even more so.
			// Rethink the way we're doing this?
			getTarget: () -> {
				investigate()
					.findAncestorComponent(Dropdown)
					.orThrow('No Dropdown')
					.investigate()
					.findComponent(DropdownToggle, true)
					.orThrow('No dropdown toggle')
					.investigate()
					.getPrimitive();
			},
			gap: gap,
			attachment: attachment,
			child: child
		});
	}

	#if (js && !nodejs)
	var current:Null<DropdownItem> = null;

	function setup() {
		var controller = new js.html.AbortController();
		var document = js.Browser.document;

		document.addControlledEventListener('keydown', onKeyDown, controller);
		document.addControlledEventListener('click', hide, controller);

		maybeFocusFirst();

		addDisposable(() -> {
			controller.abort();
			FocusContext.maybeFrom(this).inspect(focus -> focus.returnFocus());
		});
	}

	function hide(e:js.html.Event) {
		e.stopPropagation();
		e.preventDefault();
		onHide();
	}

	function getNextFocusedChild(offset:Int):Maybe<Component> {
		var items = investigate().filterComponents(DropdownItem, true);
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
				var el:js.html.Element = item.investigate().getPrimitive();
				FocusContext.from(this).focus(el);
			case None:
		}
	}

	function focusNext(e:js.html.KeyboardEvent, hideIfLast:Bool = false) {
		e.preventDefault();
		switch getNextFocusedChild(1) {
			case Some(item):
				(item.investigate().getPrimitive() : js.html.Element).focus();
			case None if (hideIfLast):
				hide(e);
			case None:
		}
	}

	function focusPrevious(e:js.html.KeyboardEvent, hideIfFirst:Bool = false) {
		e.preventDefault();
		switch getNextFocusedChild(-1) {
			case Some(item):
				(item.investigate().getPrimitive() : js.html.Element).focus();
			case None if (hideIfFirst):
				hide(e);
			case None:
		}
	}

	function onKeyDown(event:js.html.KeyboardEvent) {
		switch investigate().getStatus() {
			case Rendering(_) | Disposed | Disposing: return;
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
