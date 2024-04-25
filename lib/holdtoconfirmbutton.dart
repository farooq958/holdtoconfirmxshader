import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HoldToConfirmButton extends StatefulWidget {
  final double? width;
  final double? height;
  const HoldToConfirmButton({super.key, this.width, this.height});

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton> {

  double animatedWidth=0;
  Timer? timer;
  Offset  scaleOffset=const Offset(0, 0);
Offset endOffset=const Offset(0, 0.7);
double endVal=1;
bool animationStart=false;
late final AnimationController? _animatedController;

final _debouncerLongPress=Debouncer(milliseconds: 1200);
  final _debouncerPress=Debouncer(milliseconds: 100);


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      // onLongPress: (){
      //
      // },
      onLongPress: () async {
        print("Called  on down");
        await _animationStart();
        // _debouncerLongPress.run(() {
        //
        //
        // });

      },
      onLongPressEnd: (details){
        print("called enddd");

        setState(() {
          endVal=1;
          animatedWidth=0;
          timer?.cancel();
        });

      },
      // onLongPressCancel: (){
      //   print("called");
      //   _animationStop();
      // },
      // onTapUp: (detailTap){
      //
      // },
      onTap: (){
        setState(() {
          endVal=0.8;
        });
        _debouncerPress.run(() {
          setState(() {
            endVal=1;
          });
        });

      },


      // onTapCancel: (){
      //   setState(() {
      //     endVal=1;
      //   });
      //
      //
      // },

      child: ShaderMask(
        blendMode: BlendMode.srcATop,

        shaderCallback: (Rect bounds) {
print(animatedWidth);
          return LinearGradient(
            end: Alignment.bottomRight,

            colors:  [

              // This is the color that appears as the button is held down.
              Colors.white,

              // This color is transparent, which means it doesn't show up on the screen.
              // The gradient transitions from the fill color to transparent as the button is held down.
              // This gives the effect of the button filling up with color the longer it's held.
              Colors.white.withOpacity(0.3),
            ],
            // The stops property defines where each color is placed along the line.
            // Here we're using the same value for both stops, which creates a sharp transition at that point.
            stops: [
              0,
             animatedWidth,

            ],
          ).createShader(bounds);

        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          height:widget.height?? 200,
          width: widget.width??200,
          decoration:  BoxDecoration(

            borderRadius: BorderRadius.circular(60),
            color: Colors.black


          ),

          child: const Center(child: Text('press mee',style: TextStyle(color: Colors.white),),).animate().scaleY(),



        )

      ),
    ).animate()
        .scaleY(duration: const Duration(milliseconds: 1000 ),begin: 1 ,
        end: endVal,delay: const Duration(milliseconds: 200));
  }

  Future<void> _animationStart() async {

setState(() {
      animatedWidth+=0.08;
      endVal=0.8;
    });
  timer= Timer.periodic(const Duration(milliseconds: 50),(val) {
      print("object");
      setState(() {
        animatedWidth+=0.08;
        endVal=0.8;
      });

      if(animatedWidth >= 1.5)
        {
          endVal=1;
          animatedWidth=0;
          val.cancel();
          timer?.cancel();
         setState(() {

         });
        }

    });
    // setState(() {
    //   animatedWidth+=10;
    //   endVal=0.8;
    // });

  }

  void _animationStop() {

    setState(() {
      animatedWidth=0;
    });

  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
