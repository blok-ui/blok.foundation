package blok.foundation.animation;

import blok.ui.*;

function animate(child:Child, id:String, factory, ?options:{
  ?easing:String,
  ?duration:Int
}) {
  return Animated.node({
    keyframes: new Keyframes(id, factory),
    duration: options?.duration ?? 300,
    easing: options?.easing,
    child: child
  });
}

function animateForever(child:Child, id:String, factory, ?options:{
  ?easing:String,
  ?duration:Int
}) {
  return Animated.node({
    keyframes: new Keyframes(id, factory),
    duration: options?.duration ?? 300,
    easing: options?.easing,
    child: child,
    infinite: true
  });
}
