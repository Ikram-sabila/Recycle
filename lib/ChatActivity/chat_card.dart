import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String groupId;
  final String groupName;
  final String groupImageUrl;
  final VoidCallback onTap;

  const ChatCard({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.groupImageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 0.2),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(groupImageUrl),
              radius: 25,
            ),
            // Image.network(
            //   groupImageUrl,
            //   width: 60,
            //   height: 60,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                groupName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
