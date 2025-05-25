package ex;

import blok.*;
import blok.foundation.core.*;
import blok.foundation.layer.*;
import blok.html.*;
import ex.Core;

using Breeze;
using blok.FoundationModifiers;

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
	@:attribute final onHide:() -> Void;
	@:attribute final children:Children;
	@:attribute final hideOnEscape:Bool = true;

	public function render():Child {
		// This is the recipe for a Modal: a Layer
		// inside a Portal.
		return AutomaticPortal.wrap(Layer.node({
			hideOnEscape: hideOnEscape,
			onHide: onHide,
			child: LayerShade.node({
				takeFocus: true,
				className: Breeze.compose(
					Flex.display(),
					Flex.alignItems('center'),
					Flex.justify('center'),
					Layout.layer(2),
					Background.color('rgba(0,0,0,0.5)')
				),
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
					// The following three properties must be set for this div to
					// be focusable:
					ariaModal: 'true',
					tabIndex: -1,
					role: 'dialog'
				}).child(children)
			})
		})) // Use the `lockScroll` modifier to lock scrolling on the body
			// while the modal is active:
			.lockScroll();
	}
}
