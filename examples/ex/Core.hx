package ex;

import blok.*;
import blok.html.*;
import blok.html.HtmlEvents;

class Panel extends Component {
	@:attribute final styles:ClassName = null;
	@:attribute final children:Children;
	@:attribute final onClick:EventListener = null;

	function render() {
		return Html.div({
			className: Breeze.compose(
				Border.radius(2),
				Border.color('black', 0),
				Border.width(.5),
				Spacing.pad(4),
				styles
			)
		}).child(children);
	}
}

enum ButtonPriority {
	Primary;
	Normal;
}

class Button extends Component {
	@:attribute final label:Child;
	@:attribute final priority:ButtonPriority = Normal;
	@:attribute final action:EventListener;
	@:observable final disabled:Bool = false;

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
				Modifier.disabled(Effect.opacity(25)),
				switch priority {
					case Primary: Background.color('sky', 200);
					case Normal: null;
				}
			),
			disabled: disabled,
			onClick: action
		}, label);
	}
}
