//Sample Code: SwipeGesture

#import('../../client/app/app.dart');
#import('../../client/view/view.dart');
#import('../../client/html/html.dart');
#import('../../client/util/util.dart');
#import('../../client/event/event.dart');
#import('../../client/gesture/gesture.dart');
#import('../../client/effect/effect.dart');

/* The following pictures are distributed under Creative Commons license
 * 
 * Kim Carpenter
 * http://www.flickr.com/photos/kim_carpenter_nj/7193273252/
 * 
 * sophie
 * http://www.flickr.com/photos/sophiea/5877971398/
 * 
 * Kate
 * http://www.flickr.com/photos/sparklykate/3917477670/
 * 
 * Chris. P
 * http://www.flickr.com/photos/chr1sp/4821924725/
 * 
 * Kabacchi
 * http://www.flickr.com/photos/kabacchi/5415443624/
 */

class AlbumDemo extends Activity {
  
  final int photoCount = 5;
  int frameSize, photoSize, photoOffset, arrowSize;
  View frameInner, arrowL, arrowR;
  SwipeGesture gesture;
  
  void onCreate_() {
    title = "Alpaca Album Demo";
    
    final String flickerPrefix = "http://www.flickr.com/photos/";
    final List<String> authors = 
        ["Kim Carpenter", "sophie", "Kate", "Chris. P", "Kabacchi"];
    final List<String> authorURLs = 
        ["kim_carpenter_nj", "sophiea", "sparklykate", "chr1sp", "kabacchi"];
    final List<String> imgURLs = 
        ["7193273252", "5877971398", "3917477670", "4821924725", "5415443624"];
    
    // layout structure //
    final View frame = new View();
    frameInner = new View();
    frameInner.style.userSelect = "none";
    frame.style.overflow = "hidden";
    frame.addChild(frameInner);
    frame.profile.location = "center center";
    
    // photo //
    for (int i = 0; i < photoCount; i++) {
      View photoBox = new View();
      Image photo = new Image();
      View mask = new View();
      photoBox.addChild(photo);
      photoBox.addChild(mask);
      
      // responsive sizing
      photoBox.on.preLayout.add((LayoutEvent event) {
        photoBox.width = photoBox.height = photoSize;
        photoBox.left = photoOffset + i * frameSize;
        photoBox.top = photoOffset;
      });
      
      mask.profile.text = photo.profile.text = 
          "location: top left; width: 100%; height: 100%";
      mask.classes.add("photo-mask");
      photo.classes.add("photo");
      mask.style.userSelect = "none";
      photo.src = "res/alpaca-0${i+1}.jpg";
      frameInner.addChild(photoBox);
      
      // photo source link
      String link = "$flickerPrefix${authorURLs[i]}/${imgURLs[i]}";
      TextView caption = 
          new TextView.html("By <a href='$link'>${authors[i]}</a> @ Flickr");
      caption.classes.add("photo-caption");
      caption.style.userSelect = "none";
      caption.profile.text = "location: south center";
      photoBox.addChild(caption);
    }
    
    // left/right arrows //
    arrowL = createArrow(false);
    arrowR = createArrow(true);
    arrowL.profile.text = "location: center left";
    arrowR.profile.text = "location: center right";
    updateArrow();
    
    // responsive sizing
    frame.on.preLayout.add((LayoutEvent event) {
      Size msize = new DOMQuery(mainView).innerSize;
      frameSize = Math.min(msize.width, msize.height);
      photoSize = Math.min(frameSize - 50, 500);
      photoOffset = ((frameSize - photoSize) / 2).toInt();
      final num byWidth = (msize.width - photoSize) / 2 - 5;
      final num byHeight = photoSize / 2;
      arrowSize = Math.max(Math.min(byWidth, Math.min(byHeight, 50)), 0).toInt();
      
      frame.width = frame.height = frameInner.height = frameSize;
      frameInner.width = frameSize * photoCount;
      frameInner.left = -_index * frameSize;
      
      arrowL.width = arrowR.width = arrowSize;
      arrowL.height = arrowR.height = arrowSize * 2;
    });
    
    mainView.classes.add("black");
    mainView.addChild(frame);
    mainView.addChild(arrowL);
    mainView.addChild(arrowR);
    
    // hook gesture //
    gesture = new SwipeGesture(mainView.node, (SwipeGestureState state) {
      gesture.disable();
      final int diff = state.delta.x;
      if (diff < -50) // swipe left
        next();
      else if (diff > 50) // swipe right
        previous();
      else
        gesture.enable();
    });
    
  }
  
  
  
  // business logic //
  int _index = 0;
  
  void next() => select(_index + 1);
  
  void previous() => select(_index - 1);
  
  void select(int index) {
    if (index < 0 || index >= photoCount) {
      gesture.enable();
      return;
    }
    final Offset origin = new Offset(-_index * frameSize, 0);
    final Offset dest = new Offset(-index * frameSize, 0);
    new LinearPathMotion(frameInner.node, origin, dest, end: (MotionState state) {
      _index = index;
      updateArrow();
      gesture.enable();
    }, easing: (num x) => x * x);
  }
  
  void updateArrow() {
    arrowL.hidden = _index == 0;
    arrowR.hidden = _index == photoCount - 1;
  }
  
  // view helper //
  View createArrow(bool right) {
    final View arrow = new View(), cave = new View(), body = new View();
    arrow.addChild(cave);
    cave.addChild(body);
    
    final String caveAlign = right ? "right" : "left";
    cave.profile.text = "location: center $caveAlign; width: 200%; height: 100%";
    body.profile.text = "location: center center; width: 60%; height: 60%";
    
    arrow.classes.add("arrow");
    body.classes.add("arrow-body");
    body.style.transform = "rotate(45deg)";
    return arrow;
  }
  
}

void main() {
  new AlbumDemo().run();
}
