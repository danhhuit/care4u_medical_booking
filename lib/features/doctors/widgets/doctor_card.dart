import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int reviews;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
                onBackgroundImageError: (_, __) => const Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($reviews đánh giá)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
