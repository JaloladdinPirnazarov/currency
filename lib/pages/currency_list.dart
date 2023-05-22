import 'package:country_flags/country_flags.dart';
import 'package:currency/models/currency_model.dart';
import 'package:currency/others/constants.dart';
import 'package:currency/others/functions.dart';
import 'package:currency/pages/bottom_sheet_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrencyList extends StatefulWidget {
  const CurrencyList({Key? key}) : super(key: key);

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  Constants constants = Constants();
  Functions functions = Functions();
  List currencyList = <CurrencyModel>[];
  int count = 0;
  TextStyle style = TextStyle(
      color: Color(0xFF2D1C6D), fontSize: 15, fontWeight: FontWeight.bold);

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Currency list",
          style: TextStyle(
              color: constants.textColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          //scrollDirection: Axis.vertical,
          itemCount: currencyList.length + 1,
          itemBuilder: (BuildContext context, int position) {
            return position != currencyList.length
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                        ]),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      splashColor: Colors.red, // Цвет эффекта "ripple"
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              child: CalculatorDialog(currencyList[position]),
                            );
                          },
                        );

                        print("Clicked");
                      },
                      child: Ink(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(0, 3)),
                              ]),
                              child: currencyList[position].code != "EUR"
                                  ? CountryFlag.fromCountryCode(
                                      currencyList[position]
                                          .code
                                          .substring(0, 2),
                                      height: 46,
                                      width: 60,
                                      borderRadius: 8,
                                    )
                                  : SvgPicture.asset(
                                      constants.europeFlag,
                                      height: 64,
                                      width: 72,
                                    ),
                            ),
                            Text(
                              "${currencyList[position].code} - ${currencyList[position].title}",
                              style: style,
                            ),
                            Text(
                              "${currencyList[position].cb_price} UZS",
                              style: style,
                            ),
                            //Text(""),
                          ],
                        ),
                      ),
                    ))
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                        ]),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3)),
                          ]),
                          child: CountryFlag.fromCountryCode(
                            "UZ",
                            height: 46,
                            width: 60,
                            borderRadius: 8,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Created by Jaloladdin",
                                style: style,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
          }),
    );
  }

  void fetchData() async {
    try {
      var response = await Dio().get(constants.currencyApi);
      if (response.statusCode == 200) {
        currencyList = response.data
            .map((currency) => CurrencyModel.fromJson(currency))
            .toList();

        setState(() {
          count = currencyList.length;
        });
        print('title ${currencyList[0].title}');
      }
    } catch (e) {
      print(e);
    }
  }
}
