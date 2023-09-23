package ex;

import ex.Core.Button;
import blok.html.Html;
import blok.ui.*;
import blok.foundation.carousel.*;

class CarouselExample extends Component {
  function render() {
    return Carousel.node({
      className: Breeze.compose(
        Sizing.width('full'),
        Sizing.height(50),
      ),
      items: [ 'foo', 'bar', 'bin', 'bax', 'bif', 'barf' ],
      initialIndex: 0,
      slide: item -> Scope.wrap(context -> {
        var carousel = CarouselContext.from(context);
        return Html.div({
          className: Breeze.compose(
            Background.color('red', 500),
            Border.style('solid'),
            Border.width(5),
            Border.color('white', 0),
            Typography.textColor('white', 0),
            Sizing.height(50),
            Layout.position('relative'),
            Layout.attach('top', 0),
            Sizing.width('full')
          ),
          onClick: _ -> carousel.next()
        }, item);
      }),
      controls: carousel -> Html.div({},
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
