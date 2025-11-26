import 'package:flutter/material.dart';
import 'package:task_note_player/player/src/domain/model/content_model.dart';

class ContentViewAction extends StatelessWidget {
  final ContentModel contentModel;

  const ContentViewAction({super.key, required this.contentModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            maxLines: 2,
            contentModel.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),

        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(
                Icons.thumb_up_off_alt_sharp,
                color: Theme.of(context).iconTheme.color,
                size: 18,
              ),
              onPressed: () {},
              label: Text(
                contentModel.like.toString(),
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                side: BorderSide(color: Colors.black12),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomLeft: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.thumb_down_off_alt_sharp,
                color: Theme.of(context).iconTheme.color,
                size: 18,
              ),
              onPressed: () {},
              label: Text(
                contentModel.disLike.toString(),
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.black12),

                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomRight: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
