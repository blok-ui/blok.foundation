import blok.foundation.core.PortalContext;
import blok.html.Html;
import blok.html.client.Client.mount;
import ex.AnimatedExample;
import ex.CollapseExample;
import ex.DropdownExample;
import ex.ModalExample;
import js.Browser;

function main() {
  mount(
    Browser.document.getElementById('root'),
    () -> PortalContext.provide(() -> new PortalContext({
      target: Browser.document.getElementById('portal')
    }), _ -> Html.div({
      className: Breeze.compose(
        Flex.display(),
        Flex.direction('column'),
        Flex.gap(3),
        Spacing.pad(10)
      )
    },
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
      AnimatedExample.node({})
    )));
}
