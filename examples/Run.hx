import blok.html.Client;
import blok.html.Html;
import ex.AnimatedExample;
import ex.CarouselExample;
import ex.CollapseExample;
import ex.DropdownExample;
import ex.ModalExample;
import js.Browser;

function main() {
	var root = Browser.document.getElementById('root');
	mount(root, Html.div({
		className: Breeze.compose(
			Flex.display(),
			Flex.direction('column'),
			Flex.gap(3),
			Spacing.pad(10)
		)
	}).child(
		Html.div({
			className: Breeze.compose(
				Flex.display(),
				Flex.gap(3)
			)
		},
			ModalExample.node({}),
			DropdownExample.node({}),
		),
		CollapseExample.node({}),
		AnimatedExample.node({}),
		CarouselExample.node({})
	));
}
