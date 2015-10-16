<%!

// This is the security salt that must match the value set in the BigBlueButton server
String salt = "bced839c079b4fe2543aefa73c7f6a57";

// This is the URL for the BigBlueButton server
String BigBlueButtonURL = "https://172.16.42.231/bigbluebutton/";

// Configuration Autentica.AuthAPICheck

//enable or disable authentication in API Globo, in environment of globo use true
boolean enableAuthAPI = false;
boolean enableTwoFactor = false;
String hostApi = "10.2.45.22";
String infoApi = "BigBlueButton";

// Send e-mail
//enable or disable send mail
boolean enableMailSend = false;
// enable or disable email auth, in environment of globo use false
boolean enableMailAuth = false;

String subject = "BigBluebutton - Sala criada com sucesso";
String from = "salaconferencia@corp.globo.com";
String host = "smtpar.globoi.com";
String user = "";
String pass = "";
Integer port = 25;


%>
