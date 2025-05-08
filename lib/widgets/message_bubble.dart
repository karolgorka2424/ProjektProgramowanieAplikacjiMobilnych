import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../config/theme.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Configure bubble colors based on theme and sender
    final bubbleColor = isMe
        ? (isDarkMode ? AppColors.sentMessageBubbleDark : AppColors.sentMessageBubbleLight)
        : (isDarkMode ? AppColors.receivedMessageBubbleDark : AppColors.receivedMessageBubbleLight);

    final textColor = isMe
        ? (isDarkMode ? AppColors.sentMessageTextDark : AppColors.sentMessageTextLight)
        : (isDarkMode ? AppColors.receivedMessageTextDark : AppColors.receivedMessageTextLight);

    // Parse timestamp
    final timestamp = message.timestamp != null
        ? DateTime.parse(message.timestamp!)
        : DateTime.now();
    final timeText = timeago.format(timestamp, locale: 'en_short');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for other user's messages
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=${message.senderId ?? 3}',
              ),
            ),

          // Spacing between avatar and bubble
          if (!isMe) const SizedBox(width: 8),

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show sender name for received messages
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        message.name,
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  // Message text
                  Text(
                    message.body,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),

                  // Message timestamp and status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          timeText,
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      if (isMe) const SizedBox(width: 4),
                      if (isMe)
                        Icon(
                          message.status == 'read'
                              ? Icons.done_all
                              : Icons.done,
                          size: 12,
                          color: message.status == 'read'
                              ? Colors.blue
                              : textColor.withOpacity(0.7),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Spacing between bubble and avatar
          if (isMe) const SizedBox(width: 8),

          // Avatar for own messages
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=${message.senderId ?? 1}',
              ),
            ),
        ],
      ),
    );
  }
}