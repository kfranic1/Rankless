import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'Company.dart';
import 'Employee.dart';

class CreateCompany extends StatefulWidget {
  final Employee employee;
  CreateCompany(this.employee);
  @override
  _CreateCompanyState createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  String name = '';
  String info = '';
  String error = '';
  String category = '';
  String country = '';
  bool creating = false;
  List<String> categories = ['loading'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(show: false),
      body: Container(
        decoration: backgroundDecoration,
        padding: EdgeInsets.all(20),
        child: creating
            ? Center(child: CircularProgressIndicator())
            : Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.white,
                    selectionHandleColor: Colors.white,
                  ),
                  primaryColor:
                      Colors.black45, // mijenja search icon kod drzava
                  // secondaryHeaderColor: Colors.white,  // nista
                  // errorColor: Colors.white,
                  // cardColor: Colors.white,             // nista
                  // textSelectionColor: Colors.white,
                  // selectedRowColor: Colors.white,
                  // canvasColor: Colors.white,           // nista
                  // accentColor: Colors.white,

                  // colorScheme: ColorScheme(
                  //     primary: Colors.white,
                  //     primaryVariant: Colors.white,
                  //     secondary: Colors.white,
                  //     secondaryVariant: Colors.white,
                  //     surface: Colors.white,
                  //     background: Colors.transparent,
                  //     error: Colors.red,
                  //     onPrimary: Colors.white,
                  //     onSecondary: Colors.white,
                  //     onSurface: Colors.white,
                  //     onBackground: Colors.transparent,
                  //     onError: Colors.red,
                  //     brightness: Brightness.light),

                  // indicatorColor: Colors.white,        // nista
                  // textSelectionColor: Colors.white,    // nista
                  // textSelectionHandleColor: Colors.white,
                  // splashColor: Colors.white,
                  // buttonColor: Colors.white,
                  hintColor: Colors.white, // boja naziva dropdowna
                  fontFamily: font,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: name,
                                validator: (value) {
                                  return value.isEmpty
                                      ? "Name can't be empty"
                                      : null;
                                },
                                decoration: registerInputDecoration.copyWith(
                                    labelText: 'Company name'),
                                style: inputTextStyle,
                                onChanged: (value) {
                                  setState(() => name = value);
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              // Theme(
                              //   data: ThemeData(
                              //       textSelectionTheme: TextSelectionThemeData(
                              //         cursorColor: Colors.white,
                              //         selectionColor: Colors.white,
                              //         /*selectionHandleColor: Colors.white*/
                              //       ),
                              //       primaryColor: Colors.white,
                              //       selectedRowColor: Colors.white,
                              //       canvasColor: Colors.white
                              // splashColor: Colors.white,

                              // cardColor: Colors.white,
                              // hintColor: Colors.white,
                              // indicatorColor: Colors.white,
                              // backgroundColor: Colors.white,
                              // buttonColor: Colors.white
                              // accentColor: Colors.white,
                              // unselectedWidgetColor: Colors.white,
                              // focusColor: Colors.white,
                              // ),
                              // child:
                              CountryCodePicker(
                                initialSelection: country,
                                showCountryOnly: true,
                                showOnlyCountryWhenClosed: true,
                                onChanged: (value) {
                                  setState(() {
                                    country = value.toCountryStringOnly();
                                  });
                                },
                                backgroundColor: Colors.black.withOpacity(0.7),
                                dialogBackgroundColor: Colors.teal[200],
                                barrierColor: Colors.transparent, //blue[900],
                                dialogTextStyle: inputTextStyle,
                                textStyle: inputTextStyle,
                                searchStyle: inputTextStyle.copyWith(
                                  color: Colors.black,
                                ),
                                searchDecoration:
                                    registerInputDecoration.copyWith(
                                        // icon: Icon(Icons.ac_unit),
                                        // counterStyle: inputTextStyle,
                                        // suffixStyle: inputTextStyle,
                                        // focusColor: Colors.yellow,
                                        // prefixStyle: inputTextStyle,
                                        // helperStyle: inputTextStyle,
                                        // labelStyle: inputTextStyle,

                                        hintStyle:
                                            TextStyle(color: Colors.white)),
                                // za popout
                                boxDecoration: popOutDecoration,
                                //  BoxDecoration(
                                //     border: Border(
                                //         bottom: BorderSide(color: Colors.white))),
                              ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              FutureBuilder(
                                future: categories.contains('loading')
                                    ? categoriesReference
                                        .doc('GSM53sSt5zOWQbndHZH6')
                                        .get()
                                        .then((value) {
                                        setState(() {
                                          categories =
                                              (value.data()['categories']
                                                      as List<dynamic>)
                                                  .map((e) => e as String)
                                                  .toList();
                                          categories.sort();
                                          categories.add('Other');
                                        });
                                      })
                                    : null,
                                builder: (context, snapshot) {
                                  return
                                      // Theme(
                                      //   data: ThemeData(
                                      //     primaryColor: Colors.white,
                                      //     hintColor: Colors.white,
                                      //   ),
                                      // child:
                                      SearchableDropdown(
                                    hint: 'Category',

                                    // underline: BorderSide(color: Colors.white),
                                    // searchBoxDecoration:
                                    //     registerInputDecoration.copyWith(
                                    //         focusColor: Colors.white,
                                    //         icon: Icon(Icons.search,
                                    //             color: Colors.white)),
                                    // dropdownSearchDecoration:
                                    //     // InputDecoration(
                                    //     //     border: OutlineInputBorder()),
                                    //     registerInputDecoration,
                                    // popupBarrierColor: Colors.white,
                                    style: inputTextStyle.copyWith(
                                        color: Colors.white),
                                    menuBackgroundColor: Colors.blue,

                                    // mode: Mode.MENU,
                                    // showSearchBox: true,
                                    isExpanded: true,
                                    items: categories
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child:
                                                Text(e, style: inputTextStyle)))
                                        .toList(),
                                    onChanged: (index) =>
                                        setState(() => category = index),
                                  );
                                  // );
                                },
                                initialData: categories,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                initialValue: info,
                                validator: (value) {
                                  return value.isEmpty
                                      ? "Info can't be empty"
                                      : null;
                                },
                                decoration: registerInputDecoration.copyWith(
                                    labelText: 'Info'),
                                style: inputTextStyle,
                                onChanged: (value) {
                                  setState(() => info = value);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red[400]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                child: Text(
                                  "Register Company with this data",
                                  style: inputTextStyle,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => creating = true);
                                    String ret = await finish();
                                    if (ret == 'OK')
                                      Navigator.pop(context);
                                    else {
                                      setState(() {
                                        creating = false;
                                        error = ret;
                                      });
                                    }
                                  }
                                },
                                style: textButtonStyleRegister,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<String> finish() async {
    String ret = '';
    await FirebaseFirestore.instance
        .collection('companies')
        .where('name', isEqualTo: this.name)
        .where('country', isEqualTo: this.country)
        .get()
        .then((value) {
      if (value.size > 0)
        ret = 'Company with same name and country already exists.';
    });
    if (ret != '') return ret;
    Company company = Company(
      name: this.name,
      industry: this.category,
      employees: [widget.employee],
      description: this.info,
      country: this.country,
      me: widget.employee,
    );
    dynamic result = await company.createCompany();
    if (result is String) return result;
    result = await widget.employee
        .updateEmployee(newAdmin: true, newCompanyUid: company.uid);
    if (result is String) return result;
    return 'OK';
  }
}
