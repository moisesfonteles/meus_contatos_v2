import 'package:flutter/material.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';
import '../controller/backup_contacts_controller.dart';
import 'contact_json_page.dart';

class BackupContactsPage extends StatefulWidget {
  const BackupContactsPage({super.key});

  @override
  State<BackupContactsPage> createState() => _BackupContactsPageState();
}

class _BackupContactsPageState extends State<BackupContactsPage> {
  final BackupContactsController _controller = BackupContactsController();

  @override
  void initState() {
    _controller.loadingObjectBox();
    super.initState();
  }

  @override
  void dispose() {
    _controller.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OtherContact>>(
      stream: _controller.behaviorListOtherContacts.stream,
      initialData: const [],
      builder: (context, snapshot) {
        return Scaffold(
          appBar: appBarOtherContacts(),
          body: snapshot.data!.isNotEmpty ? downloadContactsFinished() : downloadContactsPending(),
          floatingActionButton: floatActionButton(snapshot.data!),
        );
      }
    );
  }

  AppBar appBarOtherContacts() {
    return AppBar(
      title: StreamBuilder<List<OtherContact>>(
        stream: _controller.behaviorListOtherContacts.stream,
        initialData: const [],
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Baixar backup"),
              const SizedBox(height: 2.0,),
              snapshot.data!.isEmpty ?  const SizedBox(height: 2.0) : Text("${snapshot.data!.length} contatos", style: const TextStyle(fontSize: 14))
            ],
          );
        }
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
          const Text("Z z z ..." ,style: TextStyle(fontSize: 25)),
          const SizedBox(height: 8.0),
          const Text("Baixe seus contatos da nuvem!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget cardContactJson(List<OtherContact> contactJson, int index, OtherContact otherContact) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactJsonPage(otherContacts: contactJson, otherContact: otherContact, index: index))
          );
          _controller.loadingObjectBox();
        },
        child: Container(
          margin: const EdgeInsets.all(6.0),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.person)),
              const SizedBox(width: 2.0),
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
      ),
    );
  }

  Widget downloadContactsFinished() {
    return Center(
      child: StreamBuilder<List<OtherContact>>( 
        stream: _controller.behaviorListOtherContacts.stream,
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return const CircularProgressIndicator();
          }
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return cardContactJson(snapshot.data!, index, snapshot.data![index]);
            }, 
            separatorBuilder: (context, index) => Container(margin: const EdgeInsets.only(left: 10, right: 10), height: 2,width: double.infinity,color: Colors.grey.shade200),
            itemCount: snapshot.data!.length,
          );
        }
      ),
    );
  }

  Widget floatActionButton(List<OtherContact> listOtherContact) {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: () => _controller.consumeDataJson(),
      child: const Icon(Icons.cloud_download),
    );
  }
}