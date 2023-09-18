import 'package:url_launcher/url_launcher_string.dart';


class ContactJsonController {
  
  void callPhone(String phone) async{
    String telephoneNumber = phone.replaceAll(" ", "");
    String telephoneUrl = "tel:$telephoneNumber";
    if (await canLaunchUrlString(telephoneUrl)) {
      await launchUrlString(telephoneUrl);
    } else {
      throw "Ocorreu um erro ao tentar ligar para esse número.";
    }
  }

  void sendSms(String phone) async{
    String telephoneNumber = phone.replaceAll(" ", "");
      String smsUrl = "sms:$telephoneNumber";
      if (await canLaunchUrlString(smsUrl)) {
        await launchUrlString(smsUrl);
      } else {
        throw "Ocorreu um erro ao tentar enviar uma mensagem para esse número.";
      }
  }

  void sendEmail(String email) async{
    String emaill = email;
    String subject = 'Este é um e-mail teste';
    String body = 'Este é um corpo de um e-mail teste';   
    String emailUrl = "mailto:$emaill?subject=$subject&body=$body";
    if (await canLaunchUrlString(emailUrl)) {
      await launchUrlString(emailUrl);
    }
  }
}