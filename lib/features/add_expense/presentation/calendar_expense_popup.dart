import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../component/config/app_const.dart';
import '../../../component/config/app_style.dart';
import '../../../component/widget/popup_button.dart';

class CalendarExpensePopup extends StatefulWidget {
  const CalendarExpensePopup({super.key});

  @override
  State<CalendarExpensePopup> createState() => _CalendarExpensePopupState();
}

class _CalendarExpensePopupState extends State<CalendarExpensePopup> {
  DateTime _currentDate = DateTime.now();
  final String _locale = AppConst.defaultLocale;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat("EEEE, dd MMMM yyyy", _locale)
                      .format(_currentDate),
                  style: AppStyle.regular(size: 20),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 1.5,
                color: AppStyle.blue,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    DateFormat("MMMM yyyy", _locale).format(_currentDate),
                    style: AppStyle.regular(),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final lastMonth =
                            DateTime(_currentDate.year, _currentDate.month, 0);
                        _currentDate =
                            DateTime(lastMonth.year, lastMonth.month, 1);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final nextMonth = DateTime(
                            _currentDate.year, _currentDate.month + 1, 1);
                        _currentDate = nextMonth;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Column(
                children: [
                  TableCalendar(
                    locale: _locale,
                    focusedDay: _currentDate,
                    firstDay: DateTime(2000),
                    lastDay: _currentDate.add(const Duration(days: 90)),
                    availableGestures: AvailableGestures.horizontalSwipe,
                    daysOfWeekVisible: true,
                    headerVisible: false,
                    selectedDayPredicate: (day) {
                      return isSameDay(day, _currentDate);
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _currentDate = focusedDay;
                      });
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _currentDate = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                            color: AppStyle.blue, shape: BoxShape.circle)),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final isWeekend = day.weekday == DateTime.saturday ||
                            day.weekday == DateTime.sunday;
                        return Center(
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(
                              color: isWeekend ? Colors.red : Colors.black,
                            ),
                          ),
                        );
                      },
                      dowBuilder: (context, day) {
                        // header
                        final text = DateFormat.E(_locale).format(day);
                        final isWeekend = day.weekday == DateTime.saturday ||
                            day.weekday == DateTime.sunday;
                        return Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: isWeekend ? Colors.red : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PopupButton(
                        radius: 6,
                        onPressed: () => Get.back(),
                        size: 50,
                        color: AppStyle.homeYoutubeRed,
                        shadowColor: AppStyle.homeYoutubeHover,
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: AppStyle.bold(
                            size: 15,
                            textColor: AppStyle.whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      PopupButton(
                        onPressed: () {
                          final data = {"currentDate": _currentDate};
                          Get.back(result: data);
                        },
                        size: 50,
                        radius: 6,
                        color: AppStyle.homeYoutubeButton,
                        shadowColor: AppStyle.homeYoutubeShadow,
                        child: Text(
                          "Oke",
                          textAlign: TextAlign.center,
                          style: AppStyle.bold(
                            size: 15,
                            textColor: AppStyle.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
