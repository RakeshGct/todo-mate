import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:todo_mate/core/constants/app_colors.dart';
import 'package:todo_mate/core/constants/app_strings.dart';
import 'package:todo_mate/domain/entities/task.dart';
import 'package:todo_mate/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_mate/presentation/bloc/auth/auth_event.dart';
import 'package:todo_mate/presentation/bloc/task/task_bloc.dart';
import 'package:todo_mate/presentation/bloc/task/task_event.dart';
import 'package:todo_mate/presentation/screens/task/add_edit_task_screen.dart';
import 'package:todo_mate/presentation/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskPriority? _selectedPriority;
  bool? _selectedStatus;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TaskBloc>().add(TaskLoadRequested(authState.user.id));
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.filterBy,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3.h),
              Text(
                AppStrings.priority,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children: [
                  _buildFilterChip('All', _selectedPriority == null, () {
                    setModalState(() => _selectedPriority = null);
                    setState(() => _selectedPriority = null);
                  }),
                  ...TaskPriority.values.map(
                    (priority) => _buildFilterChip(
                      priority.toString().split('.').last.toUpperCase(),
                      _selectedPriority == priority,
                      () {
                        setModalState(() => _selectedPriority = priority);
                        setState(() => _selectedPriority = priority);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                AppStrings.status,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children: [
                  _buildFilterChip('All', _selectedStatus == null, () {
                    setModalState(() => _selectedStatus = null);
                    setState(() => _selectedStatus = null);
                  }),
                  _buildFilterChip('Completed', _selectedStatus == true, () {
                    setModalState(() => _selectedStatus = true);
                    setState(() => _selectedStatus = true);
                  }),
                  _buildFilterChip('Incomplete', _selectedStatus == false, () {
                    setModalState(() => _selectedStatus = false);
                    setState(() => _selectedStatus = false);
                  }),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TaskBloc>().add(
                      TaskFilterChanged(
                        priority: _selectedPriority,
                        status: _selectedStatus,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.divider,
      ),
    );
  }

  void _showDeleteDialog(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteTask),
        content: const Text(AppStrings.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(TaskDeleteRequested(taskId));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.tasks,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is TaskOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60.sp,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoaded) {
            if (state.filteredTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      AppStrings.noTasks,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      AppStrings.noTasksDescription,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: state.filteredTasks.length,
              itemBuilder: (context, index) {
                final task = state.filteredTasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<TaskBloc>(),
                          child: AddEditTaskScreen(task: task),
                        ),
                      ),
                    );
                  },
                  onToggle: () {
                    context.read<TaskBloc>().add(
                      TaskToggleStatusRequested(task.id),
                    );
                  },
                  onDelete: () => _showDeleteDialog(task.id),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: const AddEditTaskScreen(),
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text(AppStrings.addTask, style: TextStyle(fontSize: 15.sp)),
      ),
    );
  }
}
