import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ignore: use_key_in_widget_constructors
class CarouselSliderCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ListView(children: [
        CarouselSlider(
          items: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://technodipu.com/wp-content/uploads/2021/12/bkash-1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://www.tbsnews.net/sites/default/files/styles/big_2/public/images/2022/04/04/bkash_ramadan_cashback.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://yearlynews.com/wp-content/uploads/2019/08/bKash-recharge-50-offer.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          options: CarouselOptions(
            height: screenHeight * 0.2,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            viewportFraction: 0.8,
          ),
        ),
      ]),
    );
  }
}
