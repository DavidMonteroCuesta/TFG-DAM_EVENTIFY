import 'package:eventify/calendar/domain/entities/event.dart';
import 'package:eventify/calendar/domain/entities/events/appointment_event.dart';
import 'package:eventify/calendar/domain/entities/events/conference_event.dart';
import 'package:eventify/calendar/domain/entities/events/exam_event.dart';
import 'package:eventify/calendar/domain/entities/events/meeting_event.dart';
import 'package:eventify/calendar/domain/entities/events/task_event.dart';
import 'package:eventify/calendar/domain/entities/events_type_enum.dart';
import 'package:eventify/common/utils/priorities/priorities_enum.dart';
import 'package:flutter/material.dart';

class EventFactory {
  static Event createEvent(EventType type, Map<String, dynamic> data, String userId, BuildContext context) {
    switch (type) {
      case EventType.task:
        return TaskEvent(
          title: data['title'] as String,
          description: data['description'] as String?,
          priority: data['priority'] as Priority,
          date: data['date'] as DateTime?,
          time: data['time'] as String?,
          hasNotification: data['hasNotification'] as bool? ?? false,
          userId: userId,
        );
      case EventType.meeting:
        return MeetingEvent(
          title: data['title'] as String,
          description: data['description'] as String?,
          priority: data['priority'] as Priority,
          date: data['date'] as DateTime?,
          time:  data['time'] as String?, 
          hasNotification: data['hasNotification'] as bool? ?? false,
          userId: userId,
          location: data['location'] as String?,
        );
      case EventType.exam:
        return ExamEvent(
          title: data['title'] as String,
          description: data['description'] as String?,
          priority: data['priority'] as Priority,
          date: data['date'] as DateTime?,
          time:  data['time'] as String?, 
          hasNotification: data['hasNotification'] as bool? ?? false,
          userId: userId,
          subject: data['subject'] as String?,
        );
      case EventType.appointment:
        return AppointmentEvent(
          title: data['title'] as String,
          description: data['description'] as String?,
          priority: data['priority'] as Priority,
          date: data['date'] as DateTime?,
          time:  data['time'] as String?, 
          hasNotification: data['hasNotification'] as bool? ?? false,
          userId: userId,
          withPerson: data['withPerson'] as String?,
          withPersonYesNo: data['withPersonYesNo'] as bool? ?? false,
          location: data['location'] as String?,
        );
      case EventType.conference:
        return ConferenceEvent(
          title: data['title'] as String,
          description: data['description'] as String?,
          priority: data['priority'] as Priority,
          date: data['date'] as DateTime?,
          time:  data['time'] as String?, 
          hasNotification: data['hasNotification'] as bool? ?? false,
          userId: userId,
          location: data['location'] as String?,
        );
    }
  }
}