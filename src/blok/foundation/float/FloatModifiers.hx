package blok.foundation.float;

import blok.ui.*;

function inPopover(child:Child, attachment:PositionedAttachment, ?options:{
	?getTarget:() -> Dynamic,
	?gap:Int
}) {
	return Popover.node({
		child: child,
		attachment: attachment,
		gap: options?.gap,
		getTarget: options?.getTarget
	});
}
