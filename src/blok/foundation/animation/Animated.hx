package blok.foundation.animation;

import blok.signal.Observer;
import blok.*;
#if (js && !nodejs)
import js.Browser.window;
import js.html.Animation;
import js.html.Element;

using Reflect;
#end

class Animated extends Component {
	@:observable final keyframes:Keyframes;
	@:attribute final duration:Int;
	@:attribute final animateInitial:Bool = true;
	@:attribute final repeatCurrentAnimation:Bool = false;
	@:attribute final infinite:Bool = false;
	@:attribute final easing:String = 'linear';
	@:attribute final onStart:(context:Component) -> Void = null;
	@:attribute final onFinished:(context:Component) -> Void = null;
	@:attribute final onDispose:(context:Component) -> Void = null;
	@:children @:attribute final child:Child;

	function render() {
		return child;
	}

	#if (js && !nodejs)
	var currentKeyframes:Null<Keyframes> = null;
	var currentAnimation:Null<Animation> = null;

	function setup() {
		var first = true;
		Observer.track(() -> {
			if (currentAnimation != null) {
				currentAnimation.cancel();
				currentAnimation = null;
			}
			registerAnimation(first);
			first = false;
		});
		addDisposable(() -> {
			if (onDispose != null) onDispose(this);
		});
	}

	function registerAnimation(first:Bool = false) {
		var view = investigate();
		if (!view.isMounted()) return;

		var el:Element = view.getPrimitive();
		var duration = if (first && !animateInitial) 0 else duration;
		var keyframes = keyframes();

		if (!repeatCurrentAnimation) {
			if (currentKeyframes != null && currentKeyframes.equals(keyframes)) {
				return;
			}
		}

		currentKeyframes = keyframes;

		if (currentAnimation != null) {
			currentAnimation.cancel();
			currentAnimation = null;
		}

		function onFinished() {
			currentAnimation = null;
			if (this.onFinished != null) this.onFinished(this);
		}

		if (onStart != null) onStart(this);

		currentAnimation = registerAnimations(el, keyframes.create(this), {
			duration: duration,
			easing: easing,
			iterations: if (infinite) Math.POSITIVE_INFINITY else 1
		}, onFinished);
	}
	#end
}

#if (js && !nodejs)
private typedef AnimationOptions = {
	public final duration:Int;
	public final ?easing:String;
	public final ?iterations:Float;
}

private function registerAnimations(el:Element, keyframes:Array<Dynamic>, options:AnimationOptions, onFinished:() -> Void):Animation {
	var duration = prefersReducedMotion() ? 0 : options.duration;
	var animation = el.animate(keyframes, {
		duration: duration,
		easing: options.easing,
		iterations: options.iterations
	});

	// @todo: I don't think we want to trigger finished if we're canceling.
	// animation.addEventListener('cancel', onFinished, { once: true });
	animation.addEventListener('finish', onFinished, {once: true});

	return animation;
}

private function stopAnimations(el:Element, onFinished:() -> Void) {
	el.getAnimations()
		.map(animation -> new Future(activate -> {
			var activated = false;

			function dispatch() {
				if (activated) return;
				activated = true;
				activate(null);
			}

			animation.addEventListener('cancel', () -> dispatch(), {once: true});
			animation.addEventListener('finish', () -> dispatch(), {once: true});
			animation.cancel();
		}))
		.inParallel()
		.handle(_ -> onFinished());
}

private function prefersReducedMotion() {
	var query = window.matchMedia('(prefers-reduced-motion: reduce)');
	return query.matches;
}
#end
