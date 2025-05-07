import 'package:appointify_app/core/utils/app_text_styles.dart';
import 'package:appointify_app/core/utils/app_colors.dart';
import 'package:appointify_app/core/widgets/custom_app_bar.dart';
import 'package:appointify_app/core/widgets/custom_button.dart';
import 'package:appointify_app/features/appointments/domain/entities/time_slot_entity.dart';
import 'package:appointify_app/features/specialists/domain/entities/specialist_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_event.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_state.dart';
import 'package:appointify_app/features/appointments/presentation/views/appointments_list_screen.dart';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appointify_app/core/utils/app_images.dart';

class AppointmentBookingScreen extends StatefulWidget {
  static const String routeName = '/appointment-booking';
  final SpecialistEntity specialist;
  final AppointmentEntity? appointmentToReschedule;

  const AppointmentBookingScreen({
    super.key,
    required this.specialist,
    this.appointmentToReschedule,
  });

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;
  List<TimeSlotEntity> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    if (widget.appointmentToReschedule != null) {
      // For rescheduling, initialize with the original appointment's date and time
      _selectedDay = widget.appointmentToReschedule!.dateTime;
      _selectedTime = TimeOfDay(
        hour: widget.appointmentToReschedule!.dateTime.hour,
        minute: widget.appointmentToReschedule!.dateTime.minute,
      );
      _notesController.text = widget.appointmentToReschedule!.notes ?? '';
      
      // Log that we're rescheduling for clarity in debug mode
      debugPrint('Rescheduling appointment with ID: ${widget.appointmentToReschedule!.id}');
      debugPrint('Original date/time: ${widget.appointmentToReschedule!.dateTime}');
    } else {
      // For new bookings, start with today or tomorrow if it's past working hours
      final now = DateTime.now();
      if (now.hour >= 17) { // If it's past 5 PM, start with tomorrow
        _selectedDay = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
      }
    }
    
    // Fetch available time slots based on the selected day
    Future.microtask(() => _updateAvailableTimeSlots());
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool _isDateAvailable(DateTime date) {
    final dayName = DateFormat('EEEE').format(date).toLowerCase();
    return widget.specialist.workingDays.any(
      (day) => day.day.toLowerCase() == dayName,
    );
  }

  void _updateAvailableTimeSlots() {
    final dayName = DateFormat('EEEE').format(_selectedDay).toLowerCase();
    final workingDay =
        widget.specialist.workingDays
            .where((day) => day.day.toLowerCase() == dayName)
            .toList();

    if (workingDay.isEmpty) {
      setState(() {
        _timeSlots = [];
        _selectedTime = null;
      });
      return;
    }

    // For rescheduling, we need to treat it the same as booking for validating slots
    // Always fetch time slots with status from repository to show unavailable slots correctly
    context.read<AppointmentBloc>().add(
      TimeSlots(specialist: widget.specialist, date: _selectedDay),
    );

    // When rescheduling and the selected time becomes unavailable, clear it
    if (widget.appointmentToReschedule != null && _selectedTime != null) {
      // We'll re-validate the selected time when the time slots are loaded in the build method
      // by checking if it exists in the available time slots
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appointmentDateTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (widget.appointmentToReschedule != null) {
        // Check if only notes are being updated
        final isOnlyNotesUpdate =
            isSameDay(_selectedDay, widget.appointmentToReschedule!.dateTime) &&
            _selectedTime!.hour ==
                widget.appointmentToReschedule!.dateTime.hour &&
            _selectedTime!.minute ==
                widget.appointmentToReschedule!.dateTime.minute;

        if (isOnlyNotesUpdate) {
          // Update only notes without checking time slot availability
          context.read<AppointmentBloc>().add(
            UpdateAppointmentNotes(
              appointmentId: widget.appointmentToReschedule!.id,
              notes:
                  _notesController.text.isNotEmpty
                      ? _notesController.text
                      : null,
            ),
          );
        } else {
          // Reschedule appointment with new date/time
          context.read<AppointmentBloc>().add(
            RescheduleAppointment(
              appointmentId: widget.appointmentToReschedule!.id,
              newDateTime: appointmentDateTime,
              notes:
                  _notesController.text.isNotEmpty
                      ? _notesController.text
                      : null,
            ),
          );
        }
      } else {
        // Book new appointment
        context.read<AppointmentBloc>().add(
          BookAppointment(
            specialist: widget.specialist,
            dateTime: appointmentDateTime,
            notes:
                _notesController.text.isNotEmpty ? _notesController.text : null,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.appointmentToReschedule != null &&
                      isSameDay(
                        _selectedDay,
                        widget.appointmentToReschedule!.dateTime,
                      ) &&
                      _selectedTime!.hour ==
                          widget.appointmentToReschedule!.dateTime.hour &&
                      _selectedTime!.minute ==
                          widget.appointmentToReschedule!.dateTime.minute
                  ? 'Error updating notes: $e'
                  : 'Error ${widget.appointmentToReschedule != null ? 'rescheduling' : 'booking'} appointment: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDay = now;
    final lastDay = DateTime(now.year, now.month + 12, now.day);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: _selectedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      enabledDayPredicate: (day) {
        final now = DateTime.now();
        return !day.isBefore(now.subtract(const Duration(days: 1))) &&
            _isDateAvailable(day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _selectedTime = null;
            _updateAvailableTimeSlots();
          });
        }
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.normal,
        ),
        weekendTextStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.normal,
        ),
        disabledTextStyle: TextStyle(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          fontWeight: FontWeight.normal,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        todayTextStyle: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        disabledDecoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        defaultDecoration: BoxDecoration(
          color:
              isDarkMode
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.primary.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimeSlotSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time Slots', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          widget.appointmentToReschedule != null
              ? 'Select a new time slot or keep your current one. Unavailable slots are shown in red.'
              : 'Available slots can be selected. Unavailable slots are shown in red.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        _timeSlots.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 48,
                        color: theme.colorScheme.error.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No time slots available',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please select a different date',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _timeSlots.map((slot) {
                  // First determine if this time slot is selected
                  final isSelected = _selectedTime != null &&
                      _selectedTime!.hour == slot.time.hour &&
                      _selectedTime!.minute == slot.time.minute;

                  // Check if this is the original appointment time slot when rescheduling
                  final isOriginalAppointmentSlot = widget.appointmentToReschedule != null &&
                      widget.appointmentToReschedule!.dateTime.hour == slot.time.hour &&
                      widget.appointmentToReschedule!.dateTime.minute == slot.time.minute &&
                      isSameDay(_selectedDay, widget.appointmentToReschedule!.dateTime);

                  // Get the status of this time slot
                  final isBooked = slot.status == TimeSlotStatus.booked;
                  final isPassed = slot.status == TimeSlotStatus.passed;
                  final isPending = slot.status == TimeSlotStatus.pending;
                  final isAvailable = slot.status == TimeSlotStatus.available;

                  // When rescheduling, the original slot is always considered available
                  final isActuallyAvailable = isAvailable || isOriginalAppointmentSlot;

                  // Set styling based on status
                  Color backgroundColor;
                  Color textColor = Colors.white;
                  String? tooltip;

                  if (isOriginalAppointmentSlot) {
                    // Original appointment slots get special styling when rescheduling
                    if (isSelected) {
                      backgroundColor = theme.colorScheme.primary;
                      tooltip = 'Your current appointment time';
                    } else {
                      backgroundColor = theme.colorScheme.primary.withOpacity(0.3);
                      textColor = theme.colorScheme.onPrimary;
                      tooltip = 'Your current appointment time';
                    }
                  } else if (isBooked) {
                    // Booked slots are red and not selectable
                    backgroundColor = Colors.red.shade700;
                    tooltip = 'This slot is already booked';
                  } else if (isPassed) {
                    // Passed slots are gray and not selectable
                    backgroundColor = Colors.grey.shade600;
                    tooltip = 'This time has already passed';
                  } else if (isPending) {
                    // Pending slots are orange and not selectable
                    backgroundColor = Colors.orange.shade600;
                    tooltip = 'This slot is currently being booked by someone else';
                  } else if (isSelected) {
                    // Selected available slots use the primary color
                    backgroundColor = theme.colorScheme.primary;
                  } else {
                    // Available unselected slots
                    backgroundColor = theme.colorScheme.surface;
                    textColor = theme.colorScheme.onSurface;
                  }

                  return Tooltip(
                    message: tooltip ?? '',
                    child: Stack(
                      children: [
                        ChoiceChip(
                          label: Text(
                            slot.displayText,
                            style: TextStyle(
                              color: isSelected || (!isActuallyAvailable && !isOriginalAppointmentSlot) ? Colors.white : textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: isSelected,
                          // Allow selection if the slot is available OR it's the original appointment slot when rescheduling
                          onSelected: isActuallyAvailable ? (selected) {
                            setState(() {
                              _selectedTime = selected ? slot.time : null;
                            });
                          } : null, // Null makes the chip non-interactive
                          backgroundColor: backgroundColor,
                          selectedColor: theme.colorScheme.primary,
                          disabledColor: isBooked ? Colors.red.shade700 : 
                                      isPassed ? Colors.grey.shade600 :
                                      isPending ? Colors.orange.shade600 : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isActuallyAvailable && !isSelected
                                  ? theme.colorScheme.onSurface.withOpacity(0.2)
                                  : Colors.transparent,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          tooltip: null,
                        ),
                        // Add an indicator for the current appointment time when rescheduling
                        if (isOriginalAppointmentSlot && !isSelected)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes (Optional)', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Add any additional information...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: buildAppBar(
        context,
        title:
        widget.appointmentToReschedule != null
            ? 'Reschedule Appointment'
            : 'Book Appointment',
        showSettingsButton: false,
      ),
      body: MultiBlocListener(
        listeners: [
          // Listener for time slots and loading states
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (previous, current) => 
              current is TimeSlotsLoaded || 
              current is AppointmentLoading || 
              current is TimeSlotChecked,
            listener: (context, state) {
              if (state is TimeSlotsLoaded) {
                setState(() {
                  _timeSlots = state.slots;
                  _isLoading = false;

                  // Re-validate selected time for BOTH booking and rescheduling
                  if (_selectedTime != null) {
                    // Check if selected time is actually available in the loaded time slots
                    final matchingSlot = _timeSlots.where((slot) => 
                      slot.time.hour == _selectedTime!.hour && 
                      slot.time.minute == _selectedTime!.minute
                    ).toList();

                    // If the time slot is found but unavailable
                    if (matchingSlot.isNotEmpty && matchingSlot.first.status != TimeSlotStatus.available) {
                      // Only allow keeping the selection if this is the original appointment time for rescheduling
                      bool isSameAsOriginal = widget.appointmentToReschedule != null &&
                                             widget.appointmentToReschedule!.dateTime.hour == _selectedTime!.hour &&
                                             widget.appointmentToReschedule!.dateTime.minute == _selectedTime!.minute &&
                                             isSameDay(_selectedDay, widget.appointmentToReschedule!.dateTime);
                      
                      if (!isSameAsOriginal) {
                        _selectedTime = null;
                      }
                    }
                  }
                });
              } else if (state is AppointmentLoading) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is TimeSlotChecked) {
                if (!state.isAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This time slot is no longer available.'),
                    ),
                  );
                  _updateAvailableTimeSlots();
                }
              }
            },
          ),
          
          // Listener for errors
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (previous, current) => current is AppointmentError,
            listener: (context, state) {
              if (state is AppointmentError) {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      textColor: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              }
            },
          ),
          
          // Listener for appointment success (booked, rescheduled, updated)
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (previous, current) =>
              current is AppointmentBooked ||
              current is AppointmentRescheduled ||
              current is AppointmentUpdated,
            listener: (context, state) {
              setState(() => _isLoading = false);
              
              // Show success dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: isDarkMode
                      ? theme.colorScheme.surface
                      : Colors.white,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Assets.imagesNewPasswordDone,
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state is AppointmentBooked
                              ? 'Appointment Booked Successfully'
                              : state is AppointmentRescheduled
                              ? 'Appointment Rescheduled Successfully'
                              : 'Notes Updated Successfully',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );

              // Navigate to appointments list after a delay
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  context.read<AppointmentBloc>().add(
                    const LoadAppointments(),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppointmentsListScreen.routeName,
                    (route) => false,
                  );
                }
              });
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Specialist Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.specialist.name, style: TextStyles.bold19),
                      const SizedBox(height: 8),
                      Text(
                        "${widget.specialist.category} (${widget.specialist.specialization})",
                        style: TextStyles.regular13.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.specialist.rating.toStringAsFixed(1)} (${widget.specialist.reviewsCount})",
                            style: TextStyles.semiBold13,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            widget.specialist.workingDays.map((day) {
                              return Chip(
                                label: Text(
                                  day.day.substring(0, 3).toUpperCase(),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Calendar
              _buildCalendar(),
              const SizedBox(height: 24),
              // Time Slots
              _buildTimeSlotSection(context),
              const SizedBox(height: 24),
              // Notes
              _buildNotesSection(context),
              const SizedBox(height: 24),
              // Book Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: _isLoading ? null : _bookAppointment,
                  text:
                      _isLoading
                          ? (widget.appointmentToReschedule != null
                              ? (isSameDay(
                                        _selectedDay,
                                        widget.appointmentToReschedule?.dateTime,
                                      ) &&
                                      _selectedTime != null &&
                                      widget.appointmentToReschedule?.dateTime != null &&
                                      _selectedTime!.hour ==
                                          widget.appointmentToReschedule!.dateTime.hour &&
                                      _selectedTime!.minute ==
                                          widget.appointmentToReschedule!.dateTime.minute
                                  ? 'Updating Notes'
                                  : 'Rescheduling')
                              : 'Booking')
                          : (widget.appointmentToReschedule != null
                              ? (_selectedTime != null && 
                                 widget.appointmentToReschedule?.dateTime != null && 
                                 isSameDay(
                                    _selectedDay,
                                    widget.appointmentToReschedule!.dateTime,
                                 ) &&
                                 _selectedTime!.hour ==
                                    widget.appointmentToReschedule!.dateTime.hour &&
                                 _selectedTime!.minute ==
                                    widget.appointmentToReschedule!.dateTime.minute
                                  ? 'Update Notes'
                                  : 'Reschedule Appointment')
                              : 'Book Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
