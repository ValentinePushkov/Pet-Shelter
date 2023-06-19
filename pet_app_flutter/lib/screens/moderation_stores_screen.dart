import 'package:flutter/material.dart';
import 'package:pet_app/configuration/configuration.dart';
import 'package:pet_app/models/store.dart';
import 'package:pet_app/screens/moderation_store_details_screen.dart';
import 'package:pet_app/screens/store_details_screen.dart';
import 'package:provider/provider.dart';

class ModerationStores extends StatefulWidget {
  const ModerationStores({Key key}) : super(key: key);

  @override
  State<ModerationStores> createState() => _ModerationStoresState();
}

class _ModerationStoresState extends State<ModerationStores> {
  @override
  Widget build(BuildContext context) {
    var stores = Provider.of<List<Store>>(context);
    return Scaffold(
      body: stores.length == 0
          ? Center(
              child: Text(
                'Нет магазинов',
                style: TextStyle(color: Colors.grey[400], fontSize: 36),
              ),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 10.0),
                        ListView.builder(
                          physics: ScrollPhysics(),
                          itemCount: stores.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final store = stores[index];
                            if (store != null) {}
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ModerationStoreDetails(
                                      store: store,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 240,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              boxShadow: shadowList,
                                              image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image: NetworkImage(
                                                  store.image,
                                                ),
                                              ),
                                            ),
                                            margin: EdgeInsets.only(top: 40),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 65,
                                          bottom: 20,
                                        ),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          boxShadow: shadowList,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  store.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 21.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
