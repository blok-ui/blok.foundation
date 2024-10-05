package ex;

import blok.foundation.collapse.*;
import blok.html.*;
import blok.ui.*;
import ex.Core;

class CollapseExample extends Component {
	function render() {
		return Collapse.node({
			child: Panel.node({
				children: [
					ExampleCollapseHeader.node({child: 'Collapse'}),
					ExampleCollapseBody.node({
						children: Html.p().child('Some stuff').node()
					})
				]
			})
		});
	}
}

class ExampleCollapseHeader extends Component {
	@:attribute final child:Child;
	@:computed final display:String = switch CollapseContext.from(this).status() {
			case Collapsed: '+';
			case Expanded: '-';
		}

	function render() {
		return Html.button({
			className: Typography.fontWeight('bold'),
			onClick: _ -> CollapseContext.from(this).toggle(),
		}).child(child, ' ', display);
	}
}

class ExampleCollapseBody extends Component {
	@:attribute final children:Children;

	function render() {
		return CollapseItem.node({
			child: Html.div({
				className: // Note: Setting overflow to 'hidden' is required for
				// the Collapse to work properly.
				Layout.overflow('hidden') // Also setting box-sizing to `border-box` will make things
					// work much better, as the padding will be included in
					// when the Component calculates the size of the element.
					.with(Layout.boxSizing('border'))
			}).child(
				Html.div({
					// Note that we do NOT put the padding in the
					// main collapse target, as this will result in the collapsed
					// element still being visible even if its height is `0`.
					className: Spacing.pad('15px')
				}).child(children)
			)
		});
	}
}
