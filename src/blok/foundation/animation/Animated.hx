package blok.foundation.animation;

import blok.signal.Observer;
import blok.ui.*;

#if (js && !nodejs)
import js.Browser.window;
import js.html.Animation;
import js.html.Element;

using Reflect;
#end

class Animated extends Component {
  @:observable final keyframes:Keyframes;
  @:constant final duration:Int;
  @:constant final child:Child;
  @:constant final animateInitial:Bool = true;
  @:constant final repeatCurrentAnimation:Bool = false;
  @:constant final infinite:Bool = false;
  @:constant final easing:String = 'linear';
  @:constant final onFinished:(context:Component)->Void = null;
  @:constant final onDispose:(context:Component)->Void = null;

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
    switch __status {
      case Disposing | Disposed: return;
      default:
    }

    var el:Element = getRealNode();
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

private function registerAnimations(el:Element, keyframes:Array<Dynamic>, options:AnimationOptions, onFinished:()->Void):Animation {
  var duration = prefersReducedMotion() ? 0 : options.duration;
  var animation = el.animate(keyframes, { 
    duration: duration,
    easing: options.easing,
    iterations: options.iterations
  });
  
  // @todo: I don't think we want to trigger finished if we're canceling.
  // animation.addEventListener('cancel', onFinished, { once: true });
  animation.addEventListener('finish', onFinished, { once: true });

  return animation;
}

private function stopAnimations(el:Element, onFinished:()->Void) {
  kit.Task.parallel(...el.getAnimations().map(animation -> new kit.Task(activate -> {
    animation.addEventListener('cancel', () -> activate(Ok(null)), { once: true });
    animation.addEventListener('finish', () -> activate(Ok(null)), { once: true });
    animation.cancel();
  }))).handle(_ -> onFinished());

  // Promise.all(el.getAnimations().map(animation -> {
  //   return new Promise((res, _) -> {
  //     animation.addEventListener('cancel', () -> res(null), { once: true });
  //     animation.addEventListener('finish', () -> res(null), { once: true });
  //     animation.cancel();
  //   });
  // })).finally(onFinished);
}

private function prefersReducedMotion() {
  var query = window.matchMedia('(prefers-reduced-motion: reduce)');
  return query.matches;
}
#end
