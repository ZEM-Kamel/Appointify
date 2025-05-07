import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_event.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_state.dart';
import 'package:appointify_app/features/appointments/presentation/views/widgets/appointment_booking_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailScreen({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool _isCancelling = false;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _cancelAppointment() async {
    setState(() {
      _isCancelling = true;
    });

    final appointmentBloc = context.read<AppointmentBloc>();
    appointmentBloc.add(CancelAppointment(
      appointmentId: widget.appointment.id,
      reason: _reasonController.text,
    ));
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for cancellation:'),
            const SizedBox(height: 16),
            CustomTextFormField(
              textInputType: TextInputType.text,
              controller: _reasonController,
              hintText: 'Enter reason...',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please Provide A Reason Dor Cancellation'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              _cancelAppointment();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Check if the appointment time has passed
  bool get _isAppointmentPassed => widget.appointment.dateTime.isBefore(DateTime.now());
  
  // Get the effective status for display
  String get _effectiveStatus {
    // If appointment is scheduled but time has passed, treat it as completed
    if (widget.appointment.status == 'scheduled' && _isAppointmentPassed) {
      return 'completed';
    }
    return widget.appointment.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: buildAppBar(context, title: 'Appointment Details' , showSettingsButton: false),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AppointmentCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment Cancelled Successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<AppointmentBloc>().add(const LoadAppointments());
            Navigator.pop(context);
          } else if (state is AppointmentRescheduled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment Rescheduled Successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<AppointmentBloc>().add(const LoadAppointments());
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppointmentStatus(context).animate().fadeIn(),
              const SizedBox(height: 24),
              _buildSpecialistInfo(context).animate().fadeIn(
                    delay: const Duration(milliseconds: 200),
                  ),
              const SizedBox(height: 24),
              _buildAppointmentDetails(context).animate().fadeIn(
                    delay: const Duration(milliseconds: 300),
                  ),
              if (widget.appointment.notes != null) ...[
                const SizedBox(height: 24),
                _buildNotesSection(context).animate().fadeIn(
                      delay: const Duration(milliseconds: 400),
                    ),
              ],
              const SizedBox(height: 32),
              // Only show action buttons if appointment is still scheduled AND hasn't passed
              if (widget.appointment.status == 'scheduled' && !_isAppointmentPassed)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppointmentBookingScreen.routeName,
                            arguments: {
                              'specialist': widget.appointment.specialist,
                              'appointmentToReschedule': widget.appointment,
                            },
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Reschedule'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 500),
                        ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isCancelling ? null : _showCancelDialog,
                        icon: _isCancelling
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.cancel_outlined),
                        label: Text(_isCancelling ? 'Cancelling...' : 'Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 600),
                        ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentStatus(BuildContext context) {
    final theme = Theme.of(context);
    final status = _effectiveStatus; // Use effective status that handles passed appointments
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusLabel(status),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusMessage(status),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistInfo(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: widget.appointment.specialist.imageUrl,
            width: 80,
            height: 80,
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
              child: const Icon(
                Icons.person,
                size: 60,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.appointment.specialist.name,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                widget.appointment.specialist.specialization,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentDetails(BuildContext context) {
    final theme = Theme.of(context);

    final appointmentId = widget.appointment.id;
    final safeBookingId = (appointmentId.isNotEmpty)
        ? (appointmentId.length >= 8
        ? appointmentId.substring(0, 8).toUpperCase()
        : appointmentId.toUpperCase())
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            Icons.calendar_today,
            'Date',
            DateFormat.yMMMMd().format(widget.appointment.dateTime),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.access_time,
            'Time',
            '${DateFormat.Hm().format(widget.appointment.dateTime)} - ${DateFormat.Hm().format(widget.appointment.dateTime.add(const Duration(hours: 1)))}',
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.event_note,
            'Booking ID',
            safeBookingId,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.calendar_today,
            'Booked On',
            DateFormat.yMMMMd().format(widget.appointment.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          width: double.infinity,
          child: Text(
            widget.appointment.notes ?? '',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
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

  String _getStatusMessage(String status) {
    switch (status) {
      case 'scheduled':
        return 'Your Appointment Is Confirmed';
      case 'completed':
        return 'Appointment Completed';
      case 'cancelled':
        return 'Appointment Cancelled';
      default:
        return 'Unknown Status';
    }
  }
} 