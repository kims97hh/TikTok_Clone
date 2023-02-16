import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({
    super.key,
    required this.onTapDown,
  });
  final bool onTapDown;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 600),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 20,
            child: Container(
              height: 30,
              width: 25,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: onTapDown
                    ? Theme.of(context).primaryColor
                    : const Color(0xff61d4f0),
                borderRadius: BorderRadius.circular(Sizes.size8),
              ),
            ),
          ),
          Positioned(
            left: 20,
            child: Container(
              height: 30,
              width: 25,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: onTapDown
                    ? const Color(0xff61d4f0)
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Sizes.size8),
              ),
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.size6),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.black,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
