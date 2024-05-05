import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screen/addPage.dart';
import 'package:todo/uihelper/snackbar_todo.dart';

class todo_list extends StatefulWidget {
  @override
  State<todo_list> createState() => _todo_listState();
}

class _todo_listState extends State<todo_list> {
  bool loadingg = false;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(
          "Todo App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Visibility(
        visible: loadingg,
        replacement: Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fetchdata,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              final id = item['_id'];
              return Card(
                color: Colors.grey.shade200,
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(color: Colors.white),
                      )),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['description'],
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                  ),
                  trailing: PopupMenuButton(
                
                    onSelected: (value){
                      if(value == "delete"){
                        deleteById(id);
                      }else if(value == "update"){
                        navigateToEditPage(item);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(child: Text("delete"),value: "delete",),
                        PopupMenuItem(child: Text("update"),value: "update",)
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddPage();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> fetchdata() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final results = json['items'];

      setState(() {
        items = results;
      });
    }
    else {
      print("Some error Occur..");
    }
    setState(() {
      loadingg = true;
    });
  }

  Future<void> deleteById(String id)   async{
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if(response.statusCode == 200){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
     snackbar_todo.showScussefully(context,"deletion completed");
    }else{
     snackbar_todo.showFailed(context, "Deletion Failed");
    }

  }

  Future<void> navigateToAddPage() async{
    final route =  MaterialPageRoute(builder: (context) => addPage());
    await Navigator.push(context,route);
    setState(() {
      loadingg = true;
    });
    fetchdata();
  }
  Future<void> navigateToEditPage(Map item) async{
    final route =  MaterialPageRoute(builder: (context) => addPage(todo: item));
    await Navigator.push(context,route);
    setState(() {
      loadingg = true;
    });
    fetchdata();
  }


}
