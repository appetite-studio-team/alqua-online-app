// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/language_helper/custom_text.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/providers/delivery_location_provider.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';
import 'package:souq_alqua/utils/color_class.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:souq_alqua/utils/constants.dart';
import 'package:souq_alqua/utils/image_class.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    AddressProvider provider =
        Provider.of<AddressProvider>(context, listen: false);

    Future.microtask(() async {
      await provider.fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    String translate(String key) {
      return AppLocalizations.of(context)?.translate(key) ?? key;
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          translate('delivery_address'),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, provider, child) => provider.addresses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageClass.trackingIcon,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      translate('no_delivery_address'),
                      fontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: provider.addresses.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                      border: provider.addresses[index].isDefault
                          ? Border.all(color: Colors.grey)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () => provider.updateDefaultAddress(
                          provider.addresses[index].userId,
                          provider.addresses[index].id)
                        ..then((value) {
                          floatingSnackBar(
                              message:
                                  '${provider.addresses[index].doorNo} ${translate('set_as_default')}',
                              context: context);
                        }),
                      leading: const Icon(
                        Icons.location_city,
                        color: kPrimaryColor,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${provider.addresses[index].doorNo} ${provider.addresses[index].street}'),
                            const SizedBox(width: 15),
                            if (provider.addresses[index].isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      ColorClass.kPrimaryColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: CustomText(translate('default'),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${translate('house_no')} : ${provider.addresses[index].doorNo}, Al Quoa\n ${translate('phone')} : ${provider.addresses[index].phoneNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey[500],
                                ),
                                onPressed: () async {
                                  showAddLocationBottomSheet(
                                    context,
                                    address: provider.addresses[index],
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey[500],
                                ),
                                onPressed: () async {
                                  await provider.deleteAddress(
                                      provider.addresses[index].id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlackColor,
        onPressed: () => showAddLocationBottomSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showAddLocationBottomSheet(BuildContext context, {Address? address}) {
    final TextEditingController doorNo =
        TextEditingController(text: address?.doorNo ?? '');
    final TextEditingController street =
        TextEditingController(text: address?.street ?? '');

    final TextEditingController phoneNumber =
        TextEditingController(text: address?.phoneNumber ?? '');

    showModalBottomSheet(
      isScrollControlled:
          true, // This allows the bottom sheet to adjust for the keyboard
      context: context,
      builder: (context) {
        String translate(String key) {
          return AppLocalizations.of(context)?.translate(key) ?? key;
        }

        return Consumer<AddressProvider>(
          builder: (context, snapshot, child) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjusts for the keyboard
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      address == null
                          ? translate('add_delivery_address')
                          : translate('edit_delivery_address'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    AddressCustomTextField(
                      textController: doorNo,
                      hintText: translate('enter_house_no'),
                      numKeyPad: true,
                    ),
                    const SizedBox(height: 16),
                    AddressCustomTextField(
                      textController: street,
                      hintText: translate('enter_street'),
                    ),
                    const SizedBox(height: 16),
                    AddressCustomTextField(
                      textController: phoneNumber,
                      hintText: translate('enter_phone'),
                      numKeyPad: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // validate all fields
                        if (street.text.isEmpty ||
                            doorNo.text.isEmpty ||
                            phoneNumber.text.isEmpty) {
                          floatingSnackBar(
                              message: translate('all_fields_required'),
                              context: context);

                          return;
                        }

                        // create or update address
                        if (address == null) {
                          // add address
                          await snapshot.createAddress(
                            Address(
                              id: '',
                              userId: Provider.of<LoginProvider>(context,
                                      listen: false)
                                  .emailId!,
                              doorNo: doorNo.text,
                              street: street.text,
                              phoneNumber: phoneNumber.text,
                              isDefault: false,
                            ),
                          );
                        } else {
                          // update address
                          await snapshot.updateAddress(
                            Address(
                              id: address.id,
                              userId: address.userId,
                              street: street.text,
                              doorNo: doorNo.text,
                              phoneNumber: phoneNumber.text,
                              isDefault: address.isDefault,
                            ),
                          );
                        }

                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: CustomText(
                        address == null
                            ? translate('add')
                            : translate('update'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddressCustomTextField extends StatelessWidget {
  const AddressCustomTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.numKeyPad = false,
  });

  final TextEditingController textController;
  final String hintText;
  final bool numKeyPad;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      keyboardType: hintText == 'Phone Number 🇦🇪'
          ? TextInputType.phone
          : numKeyPad
              ? TextInputType.number
              : TextInputType.text,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          fontSize: 18,
          color: Colors.grey[600],
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: ColorClass.kPrimaryColor,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: ColorClass.kPrimaryColor,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}
