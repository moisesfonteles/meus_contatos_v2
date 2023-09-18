
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
          appBar: appBarOtherContacts(),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: snapshot.data! ? downloadContactsFinished() : downloadContactsPending(),
          ),
          floatingActionButton: floatActionButton(snapshot.data!),
        );
      }
    );
  }

  AppBar appBarOtherContacts() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _controller.listJson.isEmpty ? Text("Baixar backup") : Text("Adicionar"),
          const SizedBox(height: 2.0,),
          _controller.listJson.isEmpty ?  SizedBox(height: 2.0) : Text("${_controller.listJson.length} contatos registrados ", style: TextStyle(fontSize: 14))
        ],
      ),
    );
  }

  Widget downloadContactsPending() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/porco.png", width: 200, height: 200),
          const SizedBox(height: 8.0),
          Text("Z z z ..." ,style: TextStyle(fontSize: 25)),
          const SizedBox(height: 8.0),
          const Text("Baixe seus contatos da nuvem!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget cardContactJson(List<OtherContact> contactJson, int index, OtherContact otherContact) {
    return InkWell(
      onTap: () {},
      child: Container(
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
      ),
    );
  }

  Widget downloadContactsFinished() {
    return Center(
      child: StreamBuilder<List<OtherContact>>(
        stream: _controller.behaviorListOtherContacts.stream,
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return CircularProgressIndicator(color: Colors.purple);
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 75.0),
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

  Widget floatActionButton(bool downloadFinished) {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: () => _controller.consumeDataJson(),
      child: downloadFinished == true ? Icon(Icons.check) : Icon(Icons.cloud_download),
    );
  }

}