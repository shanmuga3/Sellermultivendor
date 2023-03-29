import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/Campaign/product_list.dart';
import 'package:sellermultivendor/Screen/Campaign/provider/fetch_campaign.dart';


class Campaign_List extends StatefulWidget {
  const Campaign_List({Key? key}) : super(key: key);

  @override
  State<Campaign_List> createState() => _Campaign_ListState();
}

class _Campaign_ListState extends State<Campaign_List> {
  @override
  void initState() {
    // TODO: implement initState
    //Provider.of<fetchCampaignDataProvider>(context).fetchCampaignData(context);
    Provider.of<fetchCampaignDataProvider>(context, listen: false).fetchCampaignData(context);
    super.initState();

  }
  Widget build(BuildContext context) {
    final campaignListProvider = Provider.of<fetchCampaignDataProvider>(context);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Campaign List',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox(
              height: height/2,
              child: ListView.builder(
                 itemCount: campaignListProvider.campaignList.length,
                  itemBuilder: (context , index){
                return Padding(
                  padding: const EdgeInsets.only(left: 12,right: 12,top: 8.0,bottom: 8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(campaignListProvider.campaignList[index]["title"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                      subtitle: Text(campaignListProvider.campaignList[index]["description"]),
                      trailing: Text(campaignListProvider.campaignList[index]["start_date"]),
                    ),
                  ),
                );
              }),
            ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  Product_List(
                    flag: '',
                    fromNavbar: false,
                  )));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.pinkAccent
                      ]
                    )
                  ),
                  child: Center(child: Text("Add Campaign",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              )
        ],
      ),
          ),
      ),
    );
  }
}
