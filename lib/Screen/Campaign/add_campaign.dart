import 'package:flutter/material.dart';
import 'package:sellermultivendor/Screen/Campaign/product_list.dart';

class Add_Campaign extends StatefulWidget {
  const Add_Campaign({Key? key}) : super(key: key);

  @override
  State<Add_Campaign> createState() => _Add_CampaignState();
}

class _Add_CampaignState extends State<Add_Campaign> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Add Campaign", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                      ),
                      validator: (value) {
                        if (_titleController.text.isEmpty ?? true) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter description',
                      ),
                      validator: (value) {
                        if (_descriptionController.text.isEmpty ?? true) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? true) {
                          String title = _titleController.text;
                          String description = _descriptionController.text;
                          // Do something with the title and description
                        }
                      },
                      child: Text('Submit'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Product_List(
                                      flag: '',
                                      fromNavbar: false,
                                    )));
                      },
                      child: Text('Add Products'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
