import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

class Data {
  bool response;
  String name_firstname;
  String type_utilisateur = '';
  int utilisateur_id = 0;
  int inscription_id = 0;
  int classe_id = 0;

  Data(
      {required this.response,
      required this.name_firstname,
      required this.type_utilisateur,
      required this.utilisateur_id,
      required this.inscription_id,
      required this.classe_id});
}

chercherCookie(connect) {
  var setCookieHeader = connect.headers['set-cookie'];
  dynamic phpSessid = setCookieHeader.split(';')[0];
  return phpSessid;
}

Future authentication(String username, String password) async {
  var client = http.Client();
  var loginUrl = Uri.parse('https://mjmcloud.com/login.php');
  var protectedUrl = Uri.parse('https://mjmcloud.com/etudiant/cahier-texte');

  Map<String, String> headersConnect = {
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'fr',
    'Connection': 'keep-alive',
    'DNT': '1',
    'Host': 'mjmcloud.com',
    'Referer': 'https://mjmcloud.com/accueil',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-Fetch-User': '?1',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'sec-ch-ua': '"Not_A Brand";v="8", "Chromium";v="120"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': "macOS",
  };

  Map<String, String> formData = {
    'id_formulaire': '1',
    'username': username,
    'password': password,
  };

  var connect =
      await client.post(loginUrl, body: formData, headers: headersConnect);
  var phpSessid = chercherCookie(connect);

  Map<String, String> headers = {
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'fr',
    'Connection': 'keep-alive',
    'Cookie': phpSessid,
    'DNT': '1',
    'Host': 'mjmcloud.com',
    'Referer': 'https://mjmcloud.com/accueil',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-Fetch-User': '?1',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'sec-ch-ua': '"Not_A Brand";v="8", "Chromium";v="120"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': "macOS",
  };

  var protected = await client.get(protectedUrl, headers: headers);
  var soup = BeautifulSoup(protected.body);
  List? infos = soup.find('div',
      attrs: {'class': 'portlet light calendar'})?.findAll('input');
  var carte = soup.find('a', attrs: {'href': 'etudiant/absences'});
  if (carte != null) {
    if (infos != null) {
      Data getData() {
        bool response = true;
        String type_utilisateur = infos[0].attributes['value'];
        int utilisateur_id = int.parse(infos[1].attributes['value']);
        int inscription_id = int.parse(infos[2].attributes['value']);
        int classe_id = int.parse(infos[3].attributes['value']);
        var name_firstname = soup
            .find('span', attrs: {'class': 'username username-hide-on-mobile'});
        return Data(
            response: response,
            name_firstname: name_firstname!.text,
            type_utilisateur: type_utilisateur,
            utilisateur_id: utilisateur_id,
            inscription_id: inscription_id,
            classe_id: classe_id);
      }

      return getData();
    } else {
      Data getData() {
        bool response = false;
        var name_firstname = 'null';
        return Data(
            response: response,
            name_firstname: name_firstname,
            type_utilisateur: '',
            utilisateur_id: 0,
            inscription_id: 0,
            classe_id: 0);
      }

      return getData();
    }
  } else {
    Data getData() {
      bool response = false;
      var name_firstname = 'null';
      return Data(
          response: response,
          name_firstname: name_firstname,
          type_utilisateur: '',
          utilisateur_id: 0,
          inscription_id: 0,
          classe_id: 0);
    }

    return getData();
  }
}
