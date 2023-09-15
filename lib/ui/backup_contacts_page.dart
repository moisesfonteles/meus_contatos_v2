import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';

import '../controller/backup_contacts_controller.dart';

class BackupContactsPage extends StatefulWidget {
  const BackupContactsPage({super.key});

  @override
  State<BackupContactsPage> createState() => _BackupContactsPageState();
}

class _BackupContactsPageState extends State<BackupContactsPage> {
  final BackupContactsController _controller = BackupContactsController();

  @override
  void dispose() {
    _controller.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _controller.streamDownloadFinished.stream,
      initialData: false,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Baixar backup"),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: snapshot.data! ? downloadContactsOk() : downloadContacts(),
          ),
          floatingActionButton: floatActionButton(),
        );
      }
    );
  }

  Widget downloadContacts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/porco.png", width: 300, height: 300),
        ],
      ),
    );
  }

  Widget cardContactJson(List<OtherContact> contactJson, int index, OtherContact otherContact) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.person)),
          SizedBox(width: 2.0),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${otherContact.name}', style: const TextStyle(color: Colors.black, fontSize: 20), overflow: TextOverflow.ellipsis, maxLines: 1),
                const SizedBox(height: 2.0),
                Text('${otherContact.phone}', style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget downloadContactsOk() {
    return Center(
      child: StreamBuilder<List<OtherContact>>(
        stream: _controller.streamListOtherContacts.stream,
        builder: (context, snapshot) {
          log("-=-=-=-=-");
          log("length: ${snapshot.data?.length} | ${DateTime.now()}");
          log("-=-=-=-=-");
          if(snapshot.data == null) {
            return Text("OK");
          }
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return cardContactJson(snapshot.data!, index, snapshot.data![index]);
            }, 
            separatorBuilder: (context, index) => Container(height: 2,width: double.infinity,color: Colors.grey.shade200),
            itemCount: snapshot.data!.length,
          );
        }
      ),
    );
  }

  Widget floatActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: () => _controller.consumeDataJson(),
      child: Icon(Icons.cloud_download),
    );
  }

}