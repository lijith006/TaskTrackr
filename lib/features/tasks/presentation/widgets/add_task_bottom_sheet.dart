import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_trackr/features/tasks/domain/entities/task.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_trackr/features/tasks/presentation/bloc/task_event.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Task? task; // if null → new task, else → editing

  const AddTaskBottomSheet({super.key, this.task});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final isEditing = widget.task != null;
      final newTask = Task(
        id: isEditing ? widget.task!.id : const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _selectedDate!,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      if (isEditing) {
        context.read<TaskBloc>().add(UpdateTaskEvent(newTask));
      } else {
        context.read<TaskBloc>().add(AddTaskEvent(newTask));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2a2a2a),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Wrap(
            runSpacing: 12,
            children: [
              Text(
                isEditing ? 'Edit Task' : 'Add Task',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter task title' : null,
              ),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),

              // Due Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Due Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // const SizedBox(height: 20),
              // Priority Selector
              DropdownButtonFormField<TaskPriority>(
                value: _selectedPriority,
                items: TaskPriority.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (p) {
                  if (p != null) setState(() => _selectedPriority = p);
                },
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,

                child: InkWell(
                  onTap: _saveTask,
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/send.png',
                      width: 24,
                      height: 24,
                      color: Color(0xFF1e6f9f),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
