import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:random_string/random_string.dart';

import 'Objects.dart';

class DirectoryPage extends StatefulWidget {
  @override
  _DirectoryPageState createState() => _DirectoryPageState();

}

class _DirectoryPageState extends State<DirectoryPage> {
  
  List<FamilyMember> members = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    
    super.initState();
    loadMembers();

}

  void loadMembers() {

    members.addAll(
      List.generate(10, (index) => FamilyMember(
        (randomString( randomBetween(2, 6) ) + randomString( randomBetween(2, 6) )),
        (randomString( randomBetween(3, 9)) + "@gmail.com" ), "KCK", randomBetween(2, 100)
      ).addPhone("913709132" + randomBetween(0, 9).toString()))
    );
    members.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              style: TextStyle(color: Colors.black),
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Enter Search Here",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                )
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: members.length,
              itemBuilder: (context, index) {
                if (searchController.text.isEmpty) {
                  return Row(
                    children: [
                      MyBullet(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(members.elementAt(index).allInfo(), style: Theme.of(context).textTheme.headline5,),
                      ),
                      Expanded(
                        child: Align(
                          child: IconButton(onPressed: () {print("Edit ${members[index].name}");}, icon: Icon(Icons.edit)),
                          alignment: Alignment.centerRight,
                        )
                      )
                    ]
                  );} 
                else if (members[index].allInfo().toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
                  members[index].allInfo().toLowerCase()
                  .contains(searchController.text.toLowerCase())
                ) {
                  return Row(
                    children: [
                      MyBullet(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(members.elementAt(index).allInfo(), style: Theme.of(context).textTheme.headline5,),
                      ),
                      Expanded(
                        child: Align(
                          child: IconButton(onPressed: () {print("Edit ${members[index].name}");}, icon: Icon(Icons.edit)),
                          alignment: Alignment.centerRight,
                        )
                      )
                    ]
                  );
                } else {
                  return Container();
                }
            }),              
          ),
        ],
      )
    );
  }


}