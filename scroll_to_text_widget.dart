import 'dart:developer';

import 'package:flutter/material.dart';

class ScrollToTextWidget extends StatefulWidget {
  const ScrollToTextWidget({super.key});

  @override
  State<ScrollToTextWidget> createState() => _ScrollToTextWidgetState();
}

class _ScrollToTextWidgetState extends State<ScrollToTextWidget> {
  // Controller that will catch the target Word from the User
  late final TextEditingController _searchController;

  // The Target contrller that we will scroll from it
  late final TextEditingController _targetController;

  // The ScrollController of the TextField Widget
  late final ScrollController _scrollController;

  @override
  void initState() {
    _searchController = TextEditingController();
    _targetController = TextEditingController();

    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _targetController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void get _scrollToSearchedText {
    log("Start to Scroll .....");

    final String contentText = _targetController.text;

    final String searchText = _searchController.text;

    final int indexOfTextinContent = contentText.indexOf(searchText);

    if (indexOfTextinContent != -1 || contentText.isNotEmpty) {
      log("trying ....");
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: contentText.substring(0, indexOfTextinContent),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            textDirection: TextDirection.ltr,
          );

          // Computes the visual position of the glyphs for painting the text && Layout the text to calculate the size.
          textPainter.layout();

          // Calculate the scroll offset based on the text width and height
          final double scrollOffset = textPainter.size.height *
              (textPainter.size.width /
                  _scrollController.position.viewportDimension);

          log("Target Offset : $scrollOffset");

          // Scroll to the calculated offset
          _scrollController.animateTo(
            scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );

          // Move the cursor to the start of the searched word
          _targetController.selection = TextSelection.collapsed(
            offset: indexOfTextinContent,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
          FocusNode(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Scroll To Target Text",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.verlaFont,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                children: <Widget>[
                  gapH2,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            gapH1,
                            CustomTextFielWidget(
                              controller: _searchController,
                              title: "Target word",
                              hintText: "Enter Target Text",
                              icon: Icons.search,
                            ),
                            gapH1,
                            CustomTextFielWidget(
                              controller: _targetController,
                              hintText: "Content Text",
                              scrollController: _scrollController,
                              title: "The Text to be Searched ",
                              isTargetField: true,
                            ),
                            gapH9,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              right: 40,
              left: 40,
              child: ScrollButtonWidget(
                onScrollTap: () {
                  _scrollToSearchedText;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFielWidget extends StatelessWidget {
  const CustomTextFielWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.isTargetField = false,
    this.icon,
    this.scrollController,
  });

  final TextEditingController controller;
  final String hintText;
  final String title;
  final bool isTargetField;
  final IconData? icon;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            gapW3,
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.verlaFont,
                color: Colors.grey.withOpacity(1.0),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
            bottom: 10,
          ),
          //height: isTargetField ? context.screenHeight * .5 : null,
          child: TextField(
            controller: controller,
            scrollController: scrollController,
            scrollPhysics: const AlwaysScrollableScrollPhysics(),
            maxLines: isTargetField ? null : 1,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: isTargetField ? FontFamily.verlaFont : null,
            ),
            decoration: InputDecoration(
              constraints: BoxConstraints(
                maxHeight: isTargetField
                    ? context.screenHeight * .5
                    : context.screenHeight * .09,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.6),
                  width: 1.3,
                ),
              ),
              hintText: hintText,
              fillColor: Colors.white,
              filled: true,
              suffixIcon: isTargetField ? null : Icon(icon),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.6),
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollButtonWidget extends StatelessWidget {
  const ScrollButtonWidget({
    super.key,
    required this.onScrollTap,
  });
  final void Function() onScrollTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * .7,
      height: context.screenHeight * .07,
      child: MaterialButton(
        onPressed: onScrollTap,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Scroll To Target Text"),
      ),
    );
  }
}

