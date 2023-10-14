package ex;

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
      items: [ 'foo', 'bar', 'bin', 'bax', 'bif', 'barf' ],
      initialIndex: 0,
      onlyRenderActiveSlide: true,
      slide: (item, carousel) -> Panel.node({
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
      }),
      controls: carousel -> Html.div({
        className: Breeze.compose(
          Flex.display(),
          Flex.gap(3)
        )
      },
        Button.node({
          action: e -> carousel.previous(),
          label: 'Previous'
        }),
        Button.node({
          action: e -> carousel.next(),
          label: 'Next'
        }),
      )
    });
  }
}
