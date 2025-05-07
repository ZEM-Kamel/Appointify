import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appointify_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_cubit.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_event.dart';
import 'package:appointify_app/features/appointments/presentation/cubits/appointments_cubit/appointments_state.dart';
import 'package:appointify_app/features/appointments/presentation/views/widgets/appointment_card.dart';
import 'package:appointify_app/features/appointments/data/repos/appointment_repo_impl.dart';
import 'package:appointify_app/features/appointments/presentation/views/widgets/custom_appointments_app_bar.dart';

class AppointmentsListScreen extends StatefulWidget {
  static const String routeName = '/appointments';

  const AppointmentsListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final AppointmentBloc _appointmentBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _appointmentBloc = AppointmentBloc(AppointmentRepositoryImpl());
    _appointmentBloc.add(const LoadAppointments());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _appointmentBloc.close();
    super.dispose();
  }

  Future<void> _refreshAppointments() async {
    _appointmentBloc.add(const LoadAppointments());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: 'Appointments',
        showBackButton: true,
        showSettingsButton: false,
        tabController: _tabController,
        isAppointmentsList: true,
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        bloc: _appointmentBloc,
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading appointments...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is AppointmentError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Appointments',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed:
                          () => _appointmentBloc.add(const LoadAppointments()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AppointmentsLoaded) {
            final now = DateTime.now();

            // Categorize all appointments into their respective tabs
            final upcomingAppointments = <AppointmentEntity>[];
            final cancelledAppointments = <AppointmentEntity>[];
            final passedAppointments = <AppointmentEntity>[];

            // Process each appointment to put it in the correct category
            for (final appointment in state.appointments) {
              if (appointment.status == 'cancelled') {
                // All cancelled appointments go to the cancelled tab
                cancelledAppointments.add(appointment);
              } else if (appointment.status == 'completed') {
                // All completed appointments go to the passed tab
                passedAppointments.add(appointment);
              } else if (appointment.status == 'scheduled') {
                if (appointment.dateTime.isAfter(now)) {
                  // Future scheduled appointments go to upcoming
                  upcomingAppointments.add(appointment);
                } else {
                  // Past scheduled appointments go to passed
                  passedAppointments.add(appointment);
                }
              } else {
                // Any other status would go to upcoming for visibility
                upcomingAppointments.add(appointment);
              }
            }

            // Sort the appointments
            upcomingAppointments.sort(
              (a, b) => a.dateTime.compareTo(b.dateTime),
            ); // Upcoming sorted chronologically
            cancelledAppointments.sort(
              (a, b) => b.dateTime.compareTo(a.dateTime),
            ); // Cancelled sorted reverse chronologically
            passedAppointments.sort(
              (a, b) => b.dateTime.compareTo(a.dateTime),
            ); // Passed sorted reverse chronologically

            return TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Appointments Tab
                RefreshIndicator(
                  onRefresh: _refreshAppointments,
                  child:
                      upcomingAppointments.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 64,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Upcoming Appointments',
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your upcoming appointments will appear here',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: upcomingAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = upcomingAppointments[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/appointment-details',
                                    arguments: appointment,
                                  );
                                },
                                child: AppointmentCard(
                                  appointment: appointment,
                                  index: index,
                                ),
                              );
                            },
                          ),
                ),
                // Cancelled Appointments Tab
                RefreshIndicator(
                  onRefresh: _refreshAppointments,
                  child:
                      cancelledAppointments.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 64,
                                  color: Colors.red.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Cancelled Appointments',
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your cancelled appointments will appear here',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: cancelledAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = cancelledAppointments[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/appointment-details',
                                    arguments: appointment,
                                  );
                                },
                                child: AppointmentCard(
                                  appointment: appointment,
                                  index: index,
                                ),
                              );
                            },
                          ),
                ),
                // Passed Appointments Tab
                RefreshIndicator(
                  onRefresh: _refreshAppointments,
                  child:
                      passedAppointments.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Colors.green.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Passed Appointments',
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your passed appointments will appear here',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: passedAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = passedAppointments[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/appointment-details',
                                    arguments: appointment,
                                  );
                                },
                                child: AppointmentCard(
                                  appointment: appointment,
                                  index: index,
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          }

          return const Center(child: Text('No appointments found'));
        },
      ),
    );
  }
}
