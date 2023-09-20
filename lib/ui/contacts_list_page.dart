import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meus_contatos/ui/add_contact_page.dart';
import 'package:meus_contatos/controller/contact_list_controller.dart';
import 'package:meus_contatos/ui/contact_page.dart';
import '../model/contac_model.dart';
import 'backup_contacts_page.dart';


class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  final ContactsListController _controller = ContactsListController();

  @override
  void initState() {
    _controller.loadingFirestore();
    super.initState();
  }
  
  @override
  void dispose() {
    _controller.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Contact>>(
      stream: _controller.streamContatsList.stream,
      initialData: const [],
      builder: (context, snapshot) {
        return WillPopScope(
          onWillPop: () {
            return _controller.onLongPress(snapshot.data!);
          },
          child: Scaffold(
            drawer: drawerMyContacts(snapshot.data!),
            backgroundColor: Colors.grey[100],
            appBar: appBarMyContacts(snapshot.data!),
            body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!_controller.loadingFirestoreEnd) ...{
                        const CircularProgressIndicator(),
                    } else if(snapshot.data!.isEmpty && _controller.loadingFirestoreEnd)...{
                      contactListIsEmpty(),
                    } else ...{
                      contactsList(snapshot.data!),
                    }
                  ],
                ),
              ),
            ),
            floatingActionButton: buttonAddContact(snapshot.data!),
          ),
        );
      }
    );
  }

  AppBar appBarMyContacts(List<Contact> contacts){
    return AppBar(
      leading: _controller.longPress? InkWell(onTap: () => _controller.onLongPress(contacts), child: const Icon(Icons.arrow_back)) : null,
      title: _controller.longPress ? 
      Title(color: Colors.white, child: Text("${_controller.countSelect} selecionado(s)")) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Meus Contatos"),
          const SizedBox(height: 2.0,),
          contacts.length == 1 ? Text("${contacts.length} contato",style: const TextStyle(fontSize: 14)) : contacts.length > 1 ? Text("${contacts.length} contatos",style: const TextStyle(fontSize: 14)) : const SizedBox(height: 2.0),
        ],
      ),
    );
  }

  Widget drawerMyContacts(List<Contact> contacts){
    return Drawer(
      shadowColor: Colors.purple,
      child: ListView(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.purple,
                height: 56,
                width: double.maxFinite,
                child: Row(mainAxisAlignment: MainAxisAlignment.start,children:[ Image.asset("assets/logosemfundo.png"), const Text("Meus Contatos",style: TextStyle(color: Colors.white, fontSize: 20))]),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download, color: Colors.purple),
              title: const Text("Baixar backup", style: TextStyle(color: Colors.purple, fontSize: 20)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const BackupContactsPage()),
                );
              },
            ),
          ],
      ), 
    );
  }

  Widget contactsList(List<Contact> contacts){
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: contacts.length,
        separatorBuilder: (context, index) => Container(height: 2,width: double.infinity,color: Colors.grey.shade200),
        itemBuilder: (BuildContext context, int index ) {
          return cardContact(contacts[index], index, contacts);
        }
      ),
    );
  }

  Widget contactListIsEmpty(){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/sapo.png", width: 200, height: 200),
          const Text("Oops!", textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
          const SizedBox(height: 8.0),
          const Text("Nenhum contato registrado.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8.0),
          const Text("Adicione um novo e conecte-se!",textAlign: TextAlign.center,style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget cardContact(Contact contact, int index, List<Contact> contacts){
    return InkWell(
      onLongPress: _controller.longPress ? () {} : () => _controller.onLongPress(contacts, contact),
      onTap: _controller.longPress ? () => _controller.selectContact(contact, contacts) : () async{
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ContactPage(contacts: contacts, contact: contact, index: index))
          );
          _controller.listUptade(contacts);
      },
      child: Slidable(
        key: UniqueKey(),
        closeOnScroll: true,
        endActionPane: _controller.longPress ? null : ActionPane(
          extentRatio: 0.4,
          motion: const DrawerMotion(), 
          children: [
            SlidableAction(
              onPressed:(context) {
                _controller.callPhone(contact.phone!);
              },
              borderRadius: BorderRadius.circular(20),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.green,
              icon: Icons.phone,
            ),
            SlidableAction(
              onPressed:(context) {
                _controller.sendSms(contact.phone!);
              },
              borderRadius: BorderRadius.circular(20),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.blue,
              icon: Icons.message,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: contact.isSelected ? Colors.purple[50] : null, borderRadius: const BorderRadius.all(Radius.circular(10))),
              margin: const EdgeInsets.all(6.0),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if(contact.profileUrl == null) ...{
                    contact.isSelected ? CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.check, color: Colors.purple[100],)) :
                    const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.person)),
                    const SizedBox(width: 2.0),
                  } else ...{
                    contact.isSelected ? CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.check, color: Colors.purple[100],)) :
                    CircleAvatar(
                      backgroundColor: Colors.purple, 
                      foregroundImage: NetworkImage(contact.profileUrl as String),
                      child: const CircleAvatar(backgroundColor: Colors.purple ,maxRadius: 8, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.0))),
                      const SizedBox(width: 2.0),
                  },            
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${contact.name}', style: const TextStyle(color: Colors.black, fontSize: 20), overflow: TextOverflow.ellipsis, maxLines: 1),
                        const SizedBox(height: 2.0),
                        Text('${contact.phone}', style: const TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonAddContact(List<Contact> contacts){
    return FloatingActionButton(
      backgroundColor: _controller.longPress ? Colors.red : Colors.purple,
      onPressed: _controller.longPress ? () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Excluir este${_controller.countSelect == 1 ? "" : "s" } contato${_controller.countSelect == 1 ? "" : "s" }?"),
            content: Text("Você tem certeza que deseja excluir este${_controller.countSelect == 1 ? "" : "s" } contato${_controller.countSelect == 1 ? "" : "s" }?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => _controller.deleteContactsSelecteds(context, contacts),
                style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                child: const Text("Excluir"),
              ),
            ],
          ),
        );
      } : () async{
        Contact contact = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const AddContactPage()),
        );
        contacts.add(contact);
        contacts.sort((a, b) => a.name!.compareTo(b.name!));
        _controller.listUptade(contacts);
      },
      child: _controller.longPress ? const Icon(Icons.delete) : const Icon(Icons.add),
    );
  }
}