import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A [CircleAvatar] that loads private Frappe/ERPNext server images by
/// attaching the stored session cookie as an Authorization header.
///
/// Falls back to an initials chip when [imageUrl] is empty or image loading
/// fails.
class AuthenticatedAvatar extends StatefulWidget {
  final String imageUrl;

  /// Display name used to derive initials when no image is available.
  final String name;

  final double radius;
  final Color backgroundColor;
  final Color initialsColor;
  final double initialsFontSize;

  const AuthenticatedAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.radius = 22,
    this.backgroundColor = const Color(0xFF1C7690),
    this.initialsColor = Colors.white,
    this.initialsFontSize = 14,
  });

  @override
  State<AuthenticatedAvatar> createState() => _AuthenticatedAvatarState();
}

class _AuthenticatedAvatarState extends State<AuthenticatedAvatar> {
  static const _storage = FlutterSecureStorage();

  String? _sid;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    _loadSid();
  }

  Future<void> _loadSid() async {
    final sid = await _storage.read(key: 'sid');
    if (mounted) {
      setState(() => _sid = sid);
    }
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.imageUrl.isNotEmpty && _sid != null && !_imageError;

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      backgroundImage: hasImage
          ? NetworkImage(
              widget.imageUrl,
              headers: {'Cookie': 'sid=$_sid', 'Authorization': 'token $_sid'},
            )
          : null,
      onBackgroundImageError: hasImage
          ? (_, __) {
              if (mounted) setState(() => _imageError = true);
            }
          : null,
      child: !hasImage
          ? Text(
              _initials(widget.name),
              style: TextStyle(
                color: widget.initialsColor,
                fontWeight: FontWeight.bold,
                fontSize: widget.initialsFontSize,
              ),
            )
          : null,
    );
  }
}
