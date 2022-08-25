import 'package:flutter/material.dart';
import 'package:read_xml/models/product_model.dart';
import 'package:read_xml/network/network.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mis Productos',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mis Productos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NetWork netWork=NetWork();
  bool isLoading=true;
  bool isOnError=false;
  List<ProductModel> products=[];


  getInitData()async {
    await netWork.getListProducts(context: context).then((value){
     setState(() {
        products=value;
        isLoading=false;
     });
    }).catchError((onError){
      isOnError=true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitData();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(  
        color: const Color.fromARGB(255, 33, 69, 98),
        child: isLoading || isOnError?
         Center(
          child: isLoading? const SizedBox(
            height: 75,
            width: 75,
            child: CircularProgressIndicator(  
              
            ),
          ) :
          const Text('Error')
        )
        :
        ListView.separated(
          itemCount: products.length,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, index)=>const Divider(color: Colors.white,), 
          itemBuilder: (_, index){
            return Card(
              elevation: 10,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(  
                    products[index].url
                  ),
                ),
                title: Text(products[index].name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                subtitle: Text(products[index].description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                trailing: Text(products[index].price.toString(),
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }, 
        )

      )
    );
  }
}
