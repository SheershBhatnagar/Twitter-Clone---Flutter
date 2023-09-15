
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {

  final List<String> imageLinks;

  const CarouselImage({
    super.key,
    required this.imageLinks
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map((link) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Image.network(link, fit: BoxFit.contain),
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _current = entry.key;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key ? Colors.blue : Colors.grey
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

