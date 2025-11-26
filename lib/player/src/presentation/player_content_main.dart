import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/player/controller/player_cubit.dart';
import '../domain/model/content_model.dart';
import 'content_view/bloc/content_cubit.dart';
import 'content_view/content_view.dart';

class PlayerContentMain extends StatefulWidget {
  const PlayerContentMain({super.key});

  @override
  State<PlayerContentMain> createState() => _PlayerContentMainState();
}

class _PlayerContentMainState extends State<PlayerContentMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Content")),
      body: BlocBuilder<ContentCubit, ContentState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.contentList.length,
            itemBuilder: (context, index) {
              if (FetchStatus.fetch == state.status) {
                return Center(child: CircularProgressIndicator());
              } else if (FetchStatus.success == state.status) {
                final ContentModel content = state.contentList[index];
                final cubit = context.read<ContentCubit>();

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentView(contentModel: content),
                      ),
                    );
                  },
                  title: Text(content.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up),
                        onPressed: () =>
                            cubit.likeContent(content.id), // 💡 ВЫЗОВ CUBIT
                      ),
                      Text(
                        '${content.like}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                       IconButton(
                        icon: const Icon(Icons.thumb_down),
                        onPressed: () =>
                            cubit.dislikeContent(content.id), // 💡 ВЫЗОВ CUBIT
                      ),
                      Text(
                        '${content.disLike}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
              return Text(state.errorMessage);
            },
          );
        },
      ),
    );
  }
}
