package ex;

import blok.signal.Computation;
import blok.foundation.carousel.*;
import blok.html.Html;
import blok.ui.*;
import ex.Core;

class CarouselExample extends Component {
	function render() {
		return Carousel.node({
			className: Breeze.compose(
				Sizing.width('full'),
				Sizing.height(50),
			),
			onlyShowActiveSlides: true,
			slides: ['foo', 'bar', 'bin', 'bax', 'bif', 'barf'].map(item -> Slide.wrap(carousel -> Panel.node({
				styles: Breeze.compose(
					Sizing.height(50),
					Layout.position('relative'),
					Layout.attach('top', 0),
					Layout.layer(1),
					Sizing.width('full'),
					Typography.fontSize('6xl'),
					Typography.fontWeight('bold'),
					Flex.display(),
					Flex.alignItems('center'),
					Flex.justify('center')
				),
				onClick: _ -> carousel.next(),
				children: item
			}))).concat([
				// No need to use `Slide.wrap` unless you want to:
				carousel -> Panel.node({
					styles: Breeze.compose(
						Sizing.height(50),
						Layout.position('relative'),
						Layout.attach('top', 0),
						Layout.layer(1),
						Sizing.width('full'),
						Typography.fontSize('6xl'),
						Typography.fontWeight('bold'),
						Typography.textColor('white', 0),
						Background.color('black', 0),
						Flex.display(),
						Flex.alignItems('center'),
						Flex.justify('center')
					),
					children: 'End'
				})
				]),
			controls: carousel -> Html.div({
				className: Breeze.compose(
					Flex.display(),
					Flex.gap(3)
				)
			},
				Button.node({
					disabled: new Computation(() -> !carousel.hasPrevious()),
					action: e -> carousel.previous(),
					label: 'Previous'
				}),
				Button.node({
					disabled: new Computation(() -> !carousel.hasNext()),
					action: e -> carousel.next(),
					label: 'Next'
				}),
			)
		});
	}
}
