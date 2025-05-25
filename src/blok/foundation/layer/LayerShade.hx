package blok.foundation.layer;

import blok.foundation.core.Focused;
import blok.html.Html;

class LayerShade extends Component {
	@:attribute final className:String = null;
	@:attribute final hideOnClick:Bool = true;
	@:attribute final takeFocus:Bool = true;
	@:children @:attribute final child:Child;

	public function render():Child {
		return Html.div({
			className: className,
			style: 'position:fixed;inset:0px;overflow-x:hidden;overflow-y:scroll;',
			onClick: if (hideOnClick) e -> {
				e.preventDefault();
				LayerContext.from(this).hide();
			} else null
		}).child(if (takeFocus) {
			Focused.wrap(child);
		} else {
			child;
		});
	}
}
