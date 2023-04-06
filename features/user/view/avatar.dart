import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/user/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;

  const Avatar({
    super.key,
    required this.name, // name 변수를 받을때, required 를 해야 null을 피할 수 있다. required 가 없으면 null 오류발생.
    required this.hasAvatar,
    required this.uid,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-kims97hh.appspot.com/o/avatars%2F$uid?alt=media&캐쉬방지용=${DateTime.now().toString()}") // 캐쉬방지용은, 파일이름이 동일(link이름이 동일)하므로 내부cache로 인하여 다시 읽어오지 않아 Avatar 사진 변경이 이루어지지 않으므로 link 를 계속 변경하여 이를 방지한다
                  : null,
              child: Text(name),
            ),
    );
  }
}
