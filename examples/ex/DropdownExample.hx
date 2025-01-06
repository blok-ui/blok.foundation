package ex;

import blok.*;
import blok.foundation.dropdown.*;
import blok.html.*;
import blok.html.HtmlEvents;
import blok.signal.Computation;
import ex.Core;

using blok.foundation.dropdown.DropdownModifiers;

class DropdownExample extends Component {
	function render() {
		return Html.div({},
			Dropdown.node({
				gap: 10,
				toggle: dropdown -> Button.node({
					action: e -> {
						e.preventDefault();
						e.stopPropagation();
						dropdown.toggle();
					},
					label: new Computation(() -> switch dropdown.status() {
						case Open: 'Close Dropdown';
						case Closed: 'Open Dropdown';
					})
				}),
				child: _ -> Panel.node({
					styles: ClassName.ofArray([
						Background.color('white', 0),
						Sizing.width('min', '50px'),
						Layout.layer(10),
						Filter.dropShadow('xl')
					]),
					children: Html.ul({
						onClick: e -> e.stopPropagation(),
						className: Spacing.pad(1),
					},
						ExampleDropdownItem.node({
							onClick: _ -> trace('one'),
							child: 'One'
						}),
						ExampleDropdownItem.node({
							onClick: _ -> trace('two'),
							child: 'Two'
						}),
						ExampleDropdownItem.node({
							onClick: _ -> trace('three'),
							child: 'Three'
						})
					)
				})
			})
		);
	}
}

class ExampleDropdownItem extends Component {
	@:attribute final child:Child;
	@:attribute final onClick:EventListener;

	function render() {
		return Html.li({},
			// Note: `asDropdownItem` is used by the
			// Dropdown to figure out what items it can focus on when using
			// keyboard controls. For that reason, `asDropdownItem` should
			// be as close as possible to the actual `RealNodeComponent`
			// (`Html.a`, in this case -- note how we *didn't* us
			// it earlier, on `Html.li`), *and* that component
			// should create a focusable html element (that is, an
			// `<a>` element with a "href", a `<button>`, etc). Note that
			// the Dropdown will NOT be accessible if you don't
			// use `asDropdownItem`.
			Html.a({
				onClick: e -> {
					e.preventDefault();
					// Note: Something like this is required to
					// auto-close the dropdown when an option is
					// selected.
					DropdownContext.from(this).close();
					onClick(e);
				},
				href: '#'
			}, child).asDropdownItem()
		);
	}
}
