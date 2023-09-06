// Copyright 2023 WeKlem Inc. All rights reserved.
// Created by DongWon Choi.
// Licensed under the MIT License.

library weklem_web_youtube_player;

import 'dart:html' as html;
import 'package:flutter/material.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String youtubeLink;
  final double width;
  final double height;
  final AlignmentGeometry alignment;

  // 새로운 Mode enum
  final EScrollMode eScrollMode;

  final ScrollController? scrollController;
  final PageController? pageController;

  YouTubePlayerWidget({
    required this.youtubeLink,
    required this.width,
    required this.height,
    this.eScrollMode = EScrollMode.STATIC, // default는 STATIC
    this.scrollController,
    this.pageController,
    this.alignment = Alignment.center, // default는 center
  });

  @override
  _YouTubePlayerWidgetState createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late final String videoId;
  late final String uniqueViewType;
  late final html.DivElement div;

  // 상우 위젯의 레이아웃 정보를 받아오기 위한 키
  final GlobalKey _key = GlobalKey();
  Offset? position;

  String transformYouTubeLink(String youtubeLink) {
    final RegExp exp = RegExp(r'youtu.be/([^?]+)');
    final Iterable<RegExpMatch> matches = exp.allMatches(youtubeLink);

    if (matches.isEmpty) {
      throw FormatException('공유하기 링크로만 가능합니다.');
    }

    final videoId = matches.first.group(1)!;
    final uri = Uri.parse(youtubeLink);
    final siValue = uri.queryParameters['si'];

    this.videoId = videoId;

    if (siValue == null || siValue.isEmpty) {
      throw FormatException('Missing "si" parameter in the link');
    }

    return 'https://www.youtube.com/embed/$videoId?si=$siValue';
  }

  void _updatePosition() {
    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    position = renderBox?.localToGlobal(Offset.zero); // 위젯의 위치
  }

  void _setHtmlElementPosition() {
    if (position != null) {
      div.style
        ..position = 'absolute'
        ..top = '${position!.dy}px'
        ..left = '${position!.dx}px';
    }
  }

  void _updateOnScrollOrPageChange() {
    _updatePosition();
    _setHtmlElementPosition();
  }

  @override
  void initState() {
    super.initState();

    var link = transformYouTubeLink(widget.youtubeLink); // Extract video ID from the provided link
    uniqueViewType =
        'youtube-player-${videoId}-${DateTime.now().millisecondsSinceEpoch}';

    String width = widget.width.toString();
    String height = widget.height.toString();

    if (widget.eScrollMode == EScrollMode.SCROLL) {
      widget.scrollController?.addListener(_updateOnScrollOrPageChange);
    } else if (widget.eScrollMode == EScrollMode.PAGE_VIEW) {
      widget.pageController?.addListener(_updateOnScrollOrPageChange);
    }

    div = html.DivElement()
      ..style.width = '${width}px'
      ..style.height = '${height}px'
      ..style.position = 'relative'
      ..style.zIndex = '100'
      ..setInnerHtml(
        '<iframe width=100%; height=100%; src=${link} title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>',
        validator: html.NodeValidatorBuilder()
          ..allowHtml5()
          ..allowElement('iframe', attributes: [
            'src',
            'width',
            'height',
            'title',
            'frameborder',
            'allow',
            'allowfullscreen'
          ]),
      );

    // Attach the div to the document
    html.querySelector('body')?.children.add(div);

    // 약간의 지연 후에 위치를 업데이트합니다.
    Future.delayed(Duration(milliseconds: 100), () {
      _updatePosition();
      _setHtmlElementPosition();
    });
  }

  @override
  void dispose() {
    // When widget is disposed, remove the div from the document
    div.remove();

    if (widget.eScrollMode == EScrollMode.SCROLL) {
      widget.scrollController?.removeListener(_updateOnScrollOrPageChange);
    } else if (widget.eScrollMode == EScrollMode.PAGE_VIEW) {
      widget.pageController?.removeListener(_updateOnScrollOrPageChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 위젯의 위치를 업데이트
        _updatePosition();
        _setHtmlElementPosition();

        return Container(
          color: Colors.black,
          key: _key,
          width: widget.width,
          height: widget.height,
          child: HtmlElementView(viewType: uniqueViewType),
        );
      },
    );
  }
}

/// 스크롤 관련 모드
enum EScrollMode {
  SCROLL,
  PAGE_VIEW,
  STATIC,
}
