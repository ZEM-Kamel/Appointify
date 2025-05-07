import 'package:flutter/material.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:appointify_app/core/theme/theme_constants.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/features/appointments/presentation/views/widgets/appointment_booking_screen.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SpecialistDetailsScreen extends StatelessWidget {
  static const String routeName = '/specialist-details';

  const SpecialistDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final specialist = ModalRoute.of(context)!.settings.arguments as SpecialistEntity;

    return Scaffold(
      appBar: buildAppBar(context, title: specialist.name, showSettingsButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: ClipOval(
                  child: Image.network(
                    specialist.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 70,
                        color: theme.colorScheme.primary,
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              specialist.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              specialist.specialization,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'About',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              specialist.bio,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Working Hours',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...specialist.workingDays.map((day) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${day.day}: ${day.startTime} - ${day.endTime}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppointmentBookingScreen.routeName,
                  arguments: {
                    'specialist': specialist,
                  },
                );
              },
              text: 'Book Appointment',
            ),
          ],
        ),
      ),
    );
  }
} 