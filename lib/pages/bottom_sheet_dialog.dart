import 'package:country_flags/country_flags.dart';
import 'package:currency/models/currency_model.dart';
import 'package:currency/others/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalculatorDialog extends StatefulWidget {
  CurrencyModel currencyModel;

  CalculatorDialog(this.currencyModel);

  @override
  State<CalculatorDialog> createState() =>
      _CalculatorDialogState(currencyModel);
}

class _CalculatorDialogState extends State<CalculatorDialog> {
  CurrencyModel currencyModel;

  _CalculatorDialogState(this.currencyModel);

  TextStyle titleStyle = TextStyle(
      color: Constants().textColor, fontWeight: FontWeight.bold, fontSize: 14);

  TextStyle inputStyle = TextStyle(
      color: Constants().textColor, fontWeight: FontWeight.w400, fontSize: 32);

  TextStyle hintStyle = const TextStyle(
      color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal);

  var formatter = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
  ];
  var keyBoardType = const TextInputType.numberWithOptions(decimal: true);
  TextEditingController enteringController = TextEditingController();
  TextEditingController convertingController = TextEditingController();
  bool isCurrency = false;
  String enteringCurrency = "UZS - Uzbekistan";
  String enteringCode = "UZ";
  String enteringLabel = "";
  String convertingCurrency = "";
  String convertingCode = "";
  String convertingLabel = "";

  @override
  void initState() {
    convertingCurrency = "${currencyModel.code} - ${currencyModel.title}";
    convertingCode = currencyModel.code.substring(0, 2);
    enteringLabel =
        "1 UZS = ${doubleFormatter(1 / double.parse(currencyModel.cb_price), 8)}";
    convertingLabel = "1 ${currencyModel.code} = ${currencyModel.cb_price}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              enteringCode != "EU"
                  ? CountryFlag.fromCountryCode(
                      enteringCode,
                      height: 28,
                      width: 42,
                      borderRadius: 8,
                    )
                  : SvgPicture.asset(
                      Constants().europeFlag,
                      height: 41,
                      width: 51,
                    ),
              const SizedBox(
                width: 6,
              ),
              Text(
                enteringCurrency,
                style: titleStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text(
                enteringLabel,
                style: hintStyle,
              ),
            ],
          ),
          Row(children: [
            Expanded(child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: TextField(
                maxLength: 10,
                style: inputStyle,
                controller: enteringController,
                keyboardType: keyBoardType,
                inputFormatters: formatter,
                onChanged: onChangeListener,
                decoration: const InputDecoration(
                  counterText: '',
                  //border: InputBorder.none,
                ),
              ),
            ),),

            Container(
              margin: EdgeInsets.only(top: 60),
              child: IconButton(
                splashRadius: 30,
                onPressed: change,
                icon: SvgPicture.asset(
                  "assets/change_filled.svg",
                  width: 50,
                  height: 50,
                ),
                iconSize: 50,
              ),
            ),
          ],),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              convertingCode != "EU"
                  ? CountryFlag.fromCountryCode(
                      convertingCode,
                      height: 28,
                      width: 42,
                      borderRadius: 8,
                    )
                  : SvgPicture.asset(
                      Constants().europeFlag,
                      height: 41,
                      width: 51,
                    ),
              const SizedBox(
                width: 6,
              ),
              Text(
                convertingCurrency,
                style: titleStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text(
                convertingLabel,
                style: hintStyle,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: TextField(
              maxLength: 25,
              enabled: false,
              controller: convertingController,
              style: inputStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onChangeListener(String value) {
    double sum = value.isNotEmpty ? double.parse(value) : 0;

    if (isCurrency) {
      convertingController.text = sum == 0
          ? ''
          : doubleFormatter((sum * double.parse(currencyModel.cb_price)), 4);
    } else {
      convertingController.text = sum == 0
          ? ''
          : doubleFormatter((sum / double.parse(currencyModel.cb_price)), 4);
    }
  }

  String doubleFormatter(double value, int count) {
    String str = value.toString();
    String formatted = "";
    bool dote = false;
    int counter = 0;
    for (int i = 0; i < str.length; i++) {
      if (str[i] == '.') dote = true;

      if (dote) counter++;

      formatted += str[i];

      if (counter == count + 1) break;
    }
    return formatted;
  }

  void change() {
    if (isCurrency) {
      setState(() {
        enteringCode = "UZ";
        enteringCurrency = "UZS - Uzbekistan";
        convertingCurrency = "${currencyModel.code} - ${currencyModel.title}";
        enteringLabel =
            "1 UZS = ${doubleFormatter(1 / double.parse(currencyModel.cb_price), 8)}";
        convertingLabel = "1 ${currencyModel.code} = ${currencyModel.cb_price}";
        convertingCode = currencyModel.code.substring(0, 2);
      });
    } else {
      setState(() {
        enteringCurrency = currencyModel.code.substring(0, 2);
        enteringCode = currencyModel.code.substring(0, 2);
        convertingCode = "UZ";
        enteringLabel = "1 ${currencyModel.code} = ${currencyModel.cb_price}";
        convertingLabel =
            "1 UZS = ${doubleFormatter(1 / double.parse(currencyModel.cb_price), 8)}";
        enteringCurrency = "${currencyModel.code} - ${currencyModel.title}";
        convertingCurrency = "UZS - Uzbekistan";
      });
    }
    String temp = enteringController.text;
    enteringController.text = convertingController.text;
    convertingController.text = temp;
    isCurrency = !isCurrency;
  }
}
