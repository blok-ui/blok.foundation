package blok.foundation.dropdown;

/**
	Mark this component as a dropdown item. These items should be
	focusable (meaning buttons, inputs or anchor tags with an href).
	Components *must* be marked as dropdown items for the dropdown's
	keyboard controls to work with them.
**/
function asDropdownItem(child:Child) {
	return DropdownItem.node({child: child});
}
