import 'dart:convert';
import 'package:http/http.dart';
import 'package:project_teague_app/Objects.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';

class Paypal {

  String domain = "https://api-m.paypal.com"; // for production mode
  // String domain = "https://api-m.sandbox.paypal.com";
  BuildContext context;
  //// change clientId and secret with your own, provided by paypal
  String clientId = 'AQnM22JZoTqwT0WHk7CA-eaTFRNLyCHf0Rwzh_k66CgELkIfkL9d9M-IDAbBCO3uzSwUVtS7fxFI0wpJ';
  String secret = 'EFd4DQGN88XavS9pNSny8kzs2P1WDkVq9O9TZIK09pBII_heNalAmQ2mAaPjH9FI0fNJOhoWnXHPiF97';
  FamilyMember hoh;

  BasicAuthClient client;

  Paypal(this.context) {
    client = BasicAuthClient(clientId, secret);
  }

  Future<Invoice> createInvoice(FamilyMember hoh, InvoiceItems items) async {

    this.hoh = hoh;

    int invNum = int.parse(
      json.decode(
        (await client.post(Uri.parse('$domain/v2/invoicing/generate-next-invoice-number'))).body
      )["invoice_number"]
    );

    var response = await client.post(Uri.parse('$domain/v2/invoicing/invoices'),
      headers: {"Content-Type": "application/json",}, 
      body: json.encode(
        {
          "detail": {
            "invoice_number": invNum.toString(),
            "currency_code": "USD",
            "note": "Balance must be paid by ENTER_DATE",
            "memo": "Head of Household ID: ${hoh.id}",
            "payment_term": {
              "due_date": "2022-07-01"
            },
          },
          "invoicer": {
            "name": {
              "given_name": "KC Teague",
              "surname": "Reunion"
            },
            "address": {
              "address_line_1": "6201 Yecker Ave.",
              "admin_area_2": "Kansas City",
              "admin_area_1": "KS",
              "postal_code": "66104",
              "country_code": "US"
            },
            "email": "kcteaguereunion2022@gmail.com",
            "phones": [{
              "national_number": "9137100766",
              "phone_type": "MOBILE",
              "country_code": "001"
            }],
            "website": "www.kcteague.com",
            "tax_id": "87-1386919",
          },
          "primary_recipients": [
            {
              "billing_info": {
                "name": {
                  "given_name": hoh.name.split(" ").first,
                  "surname": hoh.name.split(" ").last
                },
                "email_address": hoh.email,
                "phones": [{
                  "country_code": "001",
                  "national_number": hoh.phone,
                  "phone_type": "MOBILE"
                }],
              }
            }
          ],
          // "additional_recipients": [
          //   {
          //     "email_address": "8.tpledger@kscholars.org"
          //   }
          // ],
          "items": items.createItemList(),
          "configuration": {
            "partial_payment": {
              "allow_partial_payment": true,
            },
            "allow_tip": false,
            "tax_inclusive": false,
          },
        }
      )
    );
    
    if(response.statusCode != 200 && response.statusCode != 201) {
      throw PaypalError(response);
    }

    Invoice ret;

    await client.post(Uri.parse(json.decode(response.body)["href"].toString() + "/send"),
      headers: {"Content-Type": "application/json",}, 
      body: json.encode({
        "send_to_invoicer": "true",
        "send_to_recipient": "true",
        "additional_recipients": [
          {"email_address": "8.tpledger@kscholars.org"}
        ]
      })
    ).then((res) async { 
      if(res.statusCode == 202 || res.statusCode == 200) {
        Map obj = json.decode((await client.get(Uri.parse(json.decode(response.body)["href"].toString()))).body);
        ret = await Invoice.toInvoice(obj);
        ret.items = items;
      }
      else
        throw PaypalError(res);
    });

    return ret;

  }

  Future<Invoice> loadInvoice(String id) async {

    var response = await client.get(Uri.parse('$domain/v2/invoicing/invoices/$id'),
      headers: {"Content-Type": "application/json",}
    );

    if(response.statusCode == 200) {
      return Invoice.toInvoice(json.decode(response.body));
    }
    else{
      throw PaypalError(response);
    }
      
  }

}

class PaypalError implements Exception {
  
  String reason;
  int code;
  
  PaypalError(Response response) : reason = response.reasonPhrase, code = response.statusCode;

}