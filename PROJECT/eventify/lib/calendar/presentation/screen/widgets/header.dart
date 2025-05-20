import 'package:eventify/calendar/presentation/screen/add_event_screen.dart';
import 'package:eventify/calendar/presentation/screen/search_events_screen.dart';
import 'package:eventify/common/theme/fonts/text_styles.dart';
import 'package:eventify/common/utils/dates/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:eventify/common/animations/ani_shining_text.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ShiningTextAnimation(
                  text: DateFormatter.getCurrentMonthAndYear(),
                  style: TextStyles.urbanistBody1,
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EventSearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AddEventScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}