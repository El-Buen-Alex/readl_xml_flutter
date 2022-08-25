
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:read_xml/models/product_model.dart';
import 'package:xml/xml.dart' as xml;

class NetWork {

  Future<List<ProductModel>> getListProducts({required BuildContext context})async{
    List<ProductModel> products =[];
    try{
      final xmlString = await DefaultAssetBundle.of(context).loadString('assets/products.xml');
      final data=xml.XmlDocument.parse(xmlString);
      final elements=data.findAllElements('data');

      for (final element in elements) {
        products.add(
          ProductModel(
            description: element.findElements('descriptionProduct').first.text,
            name: element.findElements('nameProduct').first.text,
            price: double.tryParse( element.findElements('priceProduct').first.text)??0 ,
            url: element.findElements('url').first.text,
          )
        );
      }
      
    }catch(e){
      inspect(e);
      products=[];
    }

    return products;
  }
  
}