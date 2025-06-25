import 'package:cannasoltech_automation/pages/home/start_page.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/constants.dart';
import 'end_page.dart';
import 'run_page.dart';


class CurrentRunPage extends StatefulWidget {
  const CurrentRunPage({super.key, this.stagedElement});
  final int? stagedElement;
  @override
  State<CurrentRunPage> createState() => _CurrentRunPageState();
}

class _CurrentRunPageState extends State<CurrentRunPage> {
  late int state;
  List<int> rebuildStates = [INIT, WARM_UP, RUNNING, FINISHED];
  bool rebuildFilter(prev, next) => ((prev != next) 
                                && rebuildStates.contains(next)
                                && !(prev == WARM_UP && next == RUNNING)
                                && !(prev == RUNNING && next == WARM_UP));

  int? showElement;
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, int>(
     selector: (_, model) => model.activeDeviceState,
      shouldRebuild: (previous, next) => rebuildFilter(previous, next), 
      builder: (_, state, __) {
        switch (state) {
          case INIT:     return const StartPage();
          case WARM_UP:  return const RunPage();
          case RUNNING:  return const RunPage();
          case FINISHED: return const EndPage();
          default:       return const StartPage();
        }
      }
    );
  }
}