package blok.foundation.dropdown;

class DropdownItem extends Component {
	@:children @:attribute final child:Child;

	function render() {
		return child;
	}
}
