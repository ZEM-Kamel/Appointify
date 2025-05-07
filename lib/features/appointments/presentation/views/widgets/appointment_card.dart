import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/presentation/views/widgets/appointment_detail_screen.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final int index;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    this.index = 0,
  }) : super(key: key);

  // Check if the appointment time has passed
  bool get _isAppointmentPassed => appointment.dateTime.isBefore(DateTime.now());

  // Get the effective status for display
  String get _effectiveStatus {
    // If appointment is scheduled but time has passed, treat it as completed
    if (appointment.status == 'scheduled' && _isAppointmentPassed) {
      return 'completed';
    }
    return appointment.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<AppointmentBloc>(),
                child: AppointmentDetailScreen(appointment: appointment),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialist image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: appointment.specialist.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Appointment info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.specialist.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.specialist.specialization,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_effectiveStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(_effectiveStatus),
                                size: 16,
                                color: _getStatusColor(_effectiveStatus),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getStatusLabel(_effectiveStatus),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(_effectiveStatus),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    // Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Date',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMMMd().format(appointment.dateTime),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Time',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${DateFormat.Hm().format(appointment.dateTime)} - ${DateFormat.Hm().format(appointment.dateTime.add(const Duration(hours: 1)))}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 500),
        );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'scheduled':
        return Icons.calendar_today;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.calendar_today;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'scheduled':
        return 'Scheduled';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  void _showCancelConfirmation(BuildContext context, AppointmentEntity appointment) async {
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Cancel Appointment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are You Sure You Want To Cancel Your Appointment With ${appointment.specialist.name}?',
                ),
                const SizedBox(height: 8),
                Text(
                  'Appointment Time: ${DateFormat('MMM dd, yyyy hh:mm a').format(appointment.dateTime)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cancellation Deadline: 24 hours before Appointment',
                  style: TextStyle(color: Colors.grey),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  try {
                    // Check if appointment can be cancelled
                    final canCancel = await context.read<AppointmentBloc>().canCancelAppointment(appointment.id);

                    if (!canCancel) {
                      setState(() {
                        errorMessage = 'Appointments Can Only Be Cancelled At Least 24 Hours Before The Scheduled Time.';
                        isLoading = false;
                      });
                      return;
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      _showCancellationReasonDialog(context, appointment);
                    }
                  } catch (e) {
                    setState(() {
                      errorMessage = 'Error: $e';
                      isLoading = false;
                    });
                  }
                },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Yes'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCancellationReasonDialog(BuildContext context, AppointmentEntity appointment) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancellation Reason'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Please Provide A Reason Dor Cancellation',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please Provide A Reason Dor Cancellation'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              context.read<AppointmentBloc>().add(
                CancelAppointment(
                  appointmentId: appointment.id,
                  reason: reasonController.text.trim(),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
} 