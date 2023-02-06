import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/bloc/todo_bloc.dart';
import 'package:todoapp/events/todo_event.dart';
import 'package:todoapp/helpers/db_helper.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/repositories/todo_rep.dart';
import 'package:todoapp/state/todo_state.dart';
import 'package:vibration/vibration.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController todoController = TextEditingController();
  late Future<List<TodoModel>> hh;
  List<String> minutes = [];
  List<String> seconds = [];
  int? selectedTime;
  int? selectedSEconds;
  NumberFormat formatter = new NumberFormat("00");
  @override
  void initState() {
//    selectMinutes();
  //  selectSeconds();

    super.initState();
  }

  // selectMinutes() async {
  //   for (int i = 1; i <= 10; i++) {
  //     if (i < 10) {
  //       minutes.add(formatter.format(i));
  //     } else
  //       minutes.add(formatter.format(i));
  //   }
  // }

  // selectSeconds() {
  //   for (int i = 1; i <= 59; i++) {
  //     if (i < 10) {
  //       seconds.add(formatter.format(i));
  //     } else
  //       seconds.add(formatter.format(i));
  //   }
  // }

  Stream<int> generateNumbers = (() async* {
    await Future<void>.delayed(Duration(seconds: 2));

    for (int i = 1; i <= 10; i++) {
      await Future<void>.delayed(Duration(seconds: 1));
      yield i;
    }
  })();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                  return AlertDialog(
                    content: Container(
                      height: 333,
                      //  margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "TODO",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Container(
                            width: 333,
                            height: 111,
                            child: TextField(
                              controller: todoController,
                              autofocus: false,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter TODO',
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.3),
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  //borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 22,
                            child: Row(
                              children: [
                                Text(
                                  "Duration",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  height: 33,
                                  width: 103,
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                          value: selectedTime,
                                          items: minutes.map((e) {
                                            return DropdownMenuItem<int>(
                                                value: int.parse(e),
                                                child: Text(
                                                  e.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ));
                                          }).toList(),
                                          onChanged: (v) {
                                            selectedTime = v;
                                            setState(() {});
                                          }))),
                              // SizedBox(
                              //   width: 13,
                              // ),
                              // Container(
                              //     height: 33,
                              //     width: 103,
                              //     child: DropdownButtonHideUnderline(
                              //         child: DropdownButton<int>(
                              //             value: selectedSEconds,
                              //             items: seconds.map((e) {
                              //               return DropdownMenuItem<int>(
                              //                   value: int.parse(e),
                              //                   child: Text(
                              //                     e.toString(),
                              //                     style: TextStyle(
                              //                         color: Colors.black),
                              //                   ));
                              //             }).toList(),
                              //             onChanged: (v) {
                              //               selectedSEconds = v;
                              //               setState(() {});
                              //             }))),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                var data = TodoModel(
                                    toDo: todoController.text,
                                    mintes: selectedTime,
                                    );

                                await DbHelper().addToDo(data);
                                await TodoRepo().getTodoDataRepository();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RepositoryProvider(
                                                create: (context) => TodoRepo(),
                                                child: TodoPage())));
                                setState(() {});
                              },
                              child: Text("Submit"))
                        ],
                      ),
                    ),
                  );
                });
              });
        },
      ),
      body: BlocProvider(
        create: (context) =>
            TodoBloc(todoRepo: RepositoryProvider.of<TodoRepo>(context))
              ..add(ToDoDataEvent()),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(child:
                    BlocBuilder<TodoBloc, ToDoState>(builder: (context, state) {
                  if (state is ToDoDataLoadingState) {
                    return CircularProgressIndicator();
                  }

                  if (state is ToDoDataLoadedState) {
                    return ListView.builder(
                        itemCount: state.todoData.length,
                        itemBuilder: (context, i) {
                          return Container(
                            width: 33,
                            height: 66,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 33,
                                ),
                                Text(state.todoData[i].toDo ?? ""),
                                // MyTimerWidget(
                                //   minutes: state.todoData[i].mintes??0,
                                  
                                // ),
                                // Container(
                                //     height: 333,
                                //     width: 444,
                                //     child: CountdownCard())
                              ],
                            ),
                          );
                        });
                  }

                  return CircularProgressIndicator();
                })),
              ],
            )),
      ),
    );
  }
}

class MyTimerWidget extends StatefulWidget {
  MyTimerWidget({super.key, this.minutes, });
  int? minutes;
   
  @override
  State<MyTimerWidget> createState() => _MyTimerWidgetState();
}

class _MyTimerWidgetState extends State<MyTimerWidget> {
  @override
  void initState() {
    setState(() {
      _minutes = widget.minutes ?? 0;
    });
    minuts();
    //seconds();
    super.initState();
  }

  void minuts({pausedMin,pausedSec}) {
    _minutes = pausedMin ??( widget.minutes??10)-1;
     var oneMin =  Duration( minutes: 1);
    _timer = new Timer.periodic(
      oneMin,
      (Timer timer) {
        if (_minutes == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _minutes--;
          });
        }
      },
    );
        secs = pausedSec ?? 59;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {

        if (secs == 0) {
          setState(() {


            secs = 59;
            //  timer.cancel();
          });
        } else {
          setState(() {
            secs--;
          });
        }
      },
    );
  }

  // void seconds({unp}) {
  //   secs = unp ?? widget.secs;
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {

  //       if (secs == 0) {
  //         setState(() {
  //           secs = 59;
  //           //  timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           secs--;
  //         });
  //       }
  //     },
  //   );
  // }

  pauseTimer() {
    _timer?.cancel();
  }

  void unpauseTimer() => minuts(pausedMin: _minutes,pausedSec: secs);
  Timer? _timer;
  late int _minutes;
  late int secs;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(_minutes != 10
              ? "0${_minutes.toString()}:"
              : "${_minutes.toString()}:"),
          Text(_minutes != 10 ? "${secs.toString()}" : "00"),
          GestureDetector(
              onTap: () {
                _timer?.cancel();
              },
              child: Icon(Icons.stop)),
          GestureDetector(
              onTap: () {
                unpauseTimer();
                setState(() {
                  print(_minutes);
                });
              },
              child: Icon(Icons.play_arrow))
        ],
      ),
    );
  }
}

// class CountdownCard extends StatefulWidget {
// // This widget is the root of your application.

//   @override
//   _CountdownCardState createState() => _CountdownCardState();
// }

// class _CountdownCardState extends State<CountdownCard> {
//   Timer? _timer;
//   int _start = 0;
//   bool? _vibrationActive = false;

//   void startTimer(int timerDuration) {
//     if (_timer != null) {
//       _timer?.cancel();
//       cancelVibrate();
//     }
//     setState(() {
//       _start = timerDuration;
//     });
//     const oneSec = const Duration(seconds: 1);
//     print('test');
//     _timer = new Timer.periodic(unp
//       oneSec,
//       (Timer timer) => setState(
//         () {
//           if (_start < 1) {
//             timer.cancel();
//             print('alarm');
//             // vibrate();
//           } else {
//             _start = _start - 1;
//           }
//         },
//       ),
//     );
//   }

//   void cancelVibrate() {
//     _vibrationActive = false;
//     Vibration.cancel();
//   }

// // void vibrate() async {
// //     _vibrationActive = true;

// //     if (await Vibration.hasVibrator()) {
// //     while (_vibrationActive) {
// //         Vibration.vibrate(duration: 1000);
// //         await Future.delayed(Duration(seconds: 2));
// //     }
// //     }
// // }

//   void pauseTimer() {
//     if (_timer != null) _timer?.cancel();
//   }

//   void unpauseTimer() => startTimer(_start);

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Wrap(children: <Widget>[
//       Column(
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: () {
//               startTimer(10);
//             },
//             child: Text("start"),
//           ),
//           Text("$_start"),
//           ElevatedButton(
//             onPressed: () {
//               pauseTimer();
//             },
//             child: Text("pause"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               unpauseTimer();
//             },
//             child: Text("unpause"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               cancelVibrate();
//             },
//             child: Text("stop alarm"),
//           ),
//         ],
//       ),
//     ]));
//   }
// }
