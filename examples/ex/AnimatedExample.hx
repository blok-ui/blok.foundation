package ex;

import blok.*;
import blok.html.*;

using blok.foundation.animation.AnimatedModifiers;

class AnimatedExample extends Component {
	function render() {
		return Html.div({
			className: Breeze.compose(
				Background.color('red', 500),
				Sizing.height('30px'),
				Sizing.width('30px')
			)
		}).withInfiniteAnimation('auto', _ -> [{transform: 'rotate(0)'}, {transform: 'rotate(360deg)'}], {duration: 1000});
	}
}
