

import 'package:flutter/material.dart';
import 'package:hebit_tracker_app/Componets/habit_map.dart';
import 'package:hebit_tracker_app/Datebase/habit_databash.dart';
import 'package:hebit_tracker_app/Modal/habit.dart';
import 'package:hebit_tracker_app/Provider/provider.dart';
import 'package:provider/provider.dart';

import '../Utils/habit_title.dart';
import '../Utils/habit_util.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState()
  {
  Provider.of<HabitDatabase>(context,listen: false).readHabits();
    super.initState();

  }

  final TextEditingController textController = TextEditingController();

  void createNewHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: "Create a New Habit",
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value,Habit habit){
    if(value != null)
      {
        context.read<HabitDatabase>().updateHabitCompletion(habit.id,value);
      }
  }
  void editHabitBox(Habit habit) {
    // set the controller text to the habit's current name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),

          MaterialButton(
            onPressed: () {
              // get new habit name
              String newHabitName = textController.text;

              // save to db
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // delete box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure you want to delete'),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          // delete button
          MaterialButton(
            onPressed: () {

              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text('Home'),
        actions: [
          Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          )
        ],
      ),
      body:ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () => createNewHabit(context),
        child: Icon(Icons.add,color: Colors.deepPurple,),
      ),
    );
  }

  Widget _buildHeatMap() {
    // habit database
    final habitDataBase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabit = habitDataBase.currentHabits;

    // return heatmap ui
    return FutureBuilder<DateTime?>(
      future: habitDataBase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the date is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabit),
          );
        }
        // handle case where no data is returned
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildHabitList()
  {
    final habitDatabase =context.watch<HabitDatabase>();
    List currentHabits=habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
        itemBuilder: (context,index){
        final habit =  currentHabits[index];
        bool isCompletedToday =isHabitCompletedToday(habit.completedDays);
        // return ListTile(
        //   title: Text(habit.name),
        // );
        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );


    }
    );

  }


}


// build habit list

