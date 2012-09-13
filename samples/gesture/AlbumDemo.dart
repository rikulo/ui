//Sample Code: SwipeGesture

#import("dart:math");

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
  int frameSize;
  View frameInner, arrowL, arrowR;
  SwipeGesture gesture;
  
  void onCreate_() {
    title = "Alpaca Album Demo";
    mainView.classes.add("black");
    
    final String flickerPrefix = "http://www.flickr.com/photos/";
    final String alpacaPrefix = "http://static.rikulo.org/blogs/tutorial/swipe-album/res/";
    final List<String> authors = 
        ["Kim Carpenter", "sophie", "Kate", "Chris. P", "Kabacchi"];
    final List<String> authorURLs = 
        ["kim_carpenter_nj", "sophiea", "sparklykate", "chr1sp", "kabacchi"];
    final List<String> imgURLs = 
        ["7193273252", "5877971398", "3917477670", "4821924725", "5415443624"];
    
    // layout structure //
    final View frame = new View();
    frame.style.overflow = "hidden";
    frame.profile.location = "center center";
    
    frameInner = new View();
    frame.addChild(frameInner);
    
    // photo //
    for (int i = 0; i < photoCount; i++) {
      View photoBox = new View();
      
      Image photo = new Image();
      photo.classes.add("photo");
      photo.profile.text = "location: top left; width: 100%; height: 100%";
      photo.src = "${alpacaPrefix}alpaca-0${i+1}.jpg";
      
      View mask = new View(); // to block browser's default image dragging
      mask.classes.add("photo-mask");
      mask.profile.text = "location: top left; width: 100%; height: 100%";
      
      // photo source link
      String link = "$flickerPrefix${authorURLs[i]}/${imgURLs[i]}";
      TextView caption = 
          new TextView.fromHTML("By <a href='$link'>${authors[i]}</a> @ Flickr");
      caption.classes.add("photo-caption");
      caption.style.userSelect = "none";
      caption.profile.text = "location: south center";
      
      photoBox.addChild(photo);
      photoBox.addChild(mask);
      photoBox.addChild(caption);
      frameInner.addChild(photoBox);
    }
    
    // left/right arrows //
    arrowL = createArrow(false);
    arrowR = createArrow(true);
    arrowL.profile.text = "location: center left";
    arrowR.profile.text = "location: center right";
    updateArrow();
    
    mainView.addChild(frame);
    mainView.addChild(arrowL);
    mainView.addChild(arrowR);
    
    // hook gesture //
    gesture = new SwipeGesture(mainView.node, (SwipeGestureState state) {
      gesture.disable();
      final int diff = state.transition.x;
      if (diff < -50) // swipe left
        next();
      else if (diff > 50) // swipe right
        previous();
      else
        gesture.enable();
    });
    
    // responsive sizing
    frame.on.preLayout.add((LayoutEvent event) {
      final Size msize = new DOMQuery(mainView).innerSize;
      frameSize = min(msize.width, msize.height);
      final int photoSize = min(frameSize - 50, 500);
      final int photoOffset = ((frameSize - photoSize) / 2).toInt();
      final num byWidth = (msize.width - photoSize) / 2 - 5;
      final num byHeight = photoSize / 2;
      final int arrowSize = max(min(byWidth, min(byHeight, 50)), 0).toInt();
      
      frame.width = frame.height = frameInner.height = frameSize;
      frameInner.width = frameSize * photoCount;
      frameInner.left = -_index * frameSize;
      
      for (int i = 0; i < photoCount; i++) {
        View photoBox = frameInner.children[i];
        photoBox.width = photoBox.height = photoSize;
        photoBox.left = photoOffset + i * frameSize;
        photoBox.top = photoOffset;
      }
      
      arrowL.width = arrowR.width = arrowSize;
      arrowL.height = arrowR.height = arrowSize * 2;
    });
    
  }
  
  
  
  // business logic //
  int _index = 0;
  
  void next() => select(_index + 1);
  
  void previous() => select(_index - 1);
  
  void select(int index) {
    if (index < 0 || index >= photoCount) {
      final View photo = frameInner.children[_index];
      final Offset pos = new DOMQuery(photo).offset;
      new EasingMotion((num x, MotionState state) {
        photo.style.transform = "rotate(${rand()}deg)";
        photo.left = pos.left + rand();
        photo.top = pos.top + rand();
      }, end: (MotionState state) {
        photo.style.transform = "rotate(0deg)";
        photo.left = pos.left;
        photo.top = pos.top;
        gesture.enable();
      });
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
  
  static int rand() {
    if (_rand == null)
      _rand = new Random();
	return _rand.nextInt(7) - 3;
  }
  static Random _rand;
  
  void updateArrow() {
    arrowL.visible = _index != 0;
    arrowR.visible = _index != photoCount - 1;
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
