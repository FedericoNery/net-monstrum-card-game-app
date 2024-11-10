import 'package:flutter/material.dart';

class AvatarCarousel extends StatefulWidget {
  final Function(String) onAvatarSelected;

  AvatarCarousel({required this.onAvatarSelected});

  @override
  _AvatarCarouselState createState() => _AvatarCarouselState();
}

class _AvatarCarouselState extends State<AvatarCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.3);
  int _currentPage = 0;

  final List<String> _avatars = [
    'hikari.png',
    'izzy.png',
    'joe.png',
    'mimi.png',
    'sora.png',
    'taichi.png',
    'takeru.png',
    'yamato.png',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    widget.onAvatarSelected(_avatars[index]);
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _goToNextPage() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Seleccione el avatar',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _goToPreviousPage,
            ),
            SizedBox(
              height: 200,
              width: 500,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _avatars.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  double scale = index == _currentPage ? 1.2 : 0.8;
                  return Center(
                    child: AnimatedScale(
                      scale: scale,
                      duration: Duration(milliseconds: 300),
                      child: index == _currentPage
                          ? Image.asset(
                              'assets/images/avatars/${_avatars[index]}')
                          : Image.asset(
                              'assets/images/avatars/${_avatars[index]}',
                              color: Colors.grey,
                            ),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _goToNextPage,
            ),
          ],
        ),
      ],
    );
  }
}
