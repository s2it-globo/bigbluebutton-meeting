<%@ include file="header.jsp"%>





<%@ page import="java.util.*"%>

<%@ page import="java.io.FileNotFoundException"%>

<%@ page import="java.io.IOException"%>

<%@ page import="java.io.InputStream"%>



<%@ page import="javax.mail.Message"%>

<%@ page import="javax.mail.MessagingException"%>

<%@ page import="javax.mail.PasswordAuthentication"%>

<%@ page import="javax.mail.Session"%>

<%@ page import="javax.mail.Transport"%>

<%@ page import="javax.mail.internet.InternetAddress"%>

<%@ page import="javax.mail.internet.MimeMessage"%>



<%@ page import="org.apache.commons.codec.binary.Base64"%>

<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page import="org.json.JSONObject"%>



<%@ page import="com.globo.auth.*"%>





<div class="container">



<%

	

	if (request.getParameterMap().isEmpty()) {

		response.sendRedirect("step1.jsp");

	}

		

	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String meetingName = request.getParameter("meetingName");

	//Boolean isAuthenticate = Autentica.AuthAPICheck(username, password, isEnableTwoFactor, hostApi, infoApi);
    Boolean isAuthenticate = true;

	//Generate Random Meeting Id
	//String meetingID = String.valueOf(UUID.randomUUID());

    if(isAuthenticate){
		//String responseBody = com.globo.auth.Autentica.responseBody;
    	//JSONObject jsonObj = new JSONObject(responseBody);  	

		String isRecord = "false";

		// This is the URL for to join the meeting as moderator	

		//String joinURL = getJoinURL(username, meetingID, meetingName, isRecord, "<br>Bem-vindo ao %%CONFNAME%%.<br>", null, null);

		String joinURL = getJoinURLHTML5(username, meetingName, isRecord, "<br>Bem-vindo ao %%CONFNAME%%.<br>", null, null);

		Document doc = parseXml(getURL(joinURL));

		//Extract data from the xml
		String meetingId = doc.getElementsByTagName("meeting_id").item(0).getTextContent();
		String userId = doc.getElementsByTagName("user_id").item(0).getTextContent();
		String authToken = doc.getElementsByTagName("auth_token").item(0).getTextContent();
		String ip = BigBlueButtonURL.split("\\/bigbluebutton")[0];
		String html5url = ip + "/html5client/" + meetingId + "/" + userId + "/" + authToken;

		String encodedMeetingName = URLEncoder.encode(meetingName, "UTF-8");

		String urlParameters = String.format("step3.jsp?meetingID=%s&meetingName=%s&userId=%s&authToken=%s", meetingId, encodedMeetingName, userId, authToken);

		String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
		String inviteURL = url + urlParameters;
%>

	<h2 class="form-signin-heading">

		Reuni&atilde;o '<%=StringEscapeUtils.escapeHtml(meetingName)%>' foi criada com sucesso!

	</h2>



	<br />

	<%= joinURL %>

	<div class="page-header">

		<h3>Passo 2 - Convide outras pessoas usando o seguinte link

			(mostrado abaixo):</h3>

		<p class="lead">

			<%=StringEscapeUtils.escapeHtml(inviteURL)%>

		</p>

	</div>



	<div class="page-header">

		<h3>Passo 3 - Clique no link abaixo para iniciar a sua reuni&atilde;o:</h3>

		<p class="lead">

			<a href="<%=StringEscapeUtils.escapeHtml(html5url)%>">Iniciar reuni&atilde;o</a>

		</p>

	</div>

	<%

	try {

	  Properties prop = System.getProperties();

	  String propFileName = "resources/config.properties";

	  

	  InputStream inputStream = application.getResourceAsStream(propFileName);

	  if (inputStream == null) {

		System.out.println("Arquivo não encontrado.");

	  	throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");

	  }

	

	  prop.load(inputStream);

	  // get the property value and print it out

      final String subject = prop.getProperty("subject");

	  final String from = prop.getProperty("from");

	  final String host = prop.getProperty("host");

	  final String user = prop.getProperty("user");

	  final String pass = prop.getProperty("pass");

	  final String port = prop.getProperty("port");

         

      //final String to = jsonObj.getJSONArray("mail").getString(0);

      final String to = "jose.geisler@gmail.com";

     

      // Get system properties

      Properties properties = System.getProperties();



      // Using SSL 

      properties.put("mail.smtp.host", host);

      properties.put("mail.smtp.socketFactory.port", port);

      properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

      properties.put("mail.smtp.auth", "true");

      properties.put("mail.smtp.port", port);

		

	  // Get the default Session object.

	  Session s = Session.getInstance(properties, new javax.mail.Authenticator() {

	     protected PasswordAuthentication getPasswordAuthentication() {

			return new PasswordAuthentication(user, pass);

		 }

	  });



          try {

              // Create a default MimeMessage object.

              MimeMessage message = new MimeMessage(s);



              // Set From: header field of the header.

              message.setFrom(new InternetAddress(from));



              // Set To: header field of the header.

              message.addRecipient(Message.RecipientType.TO,

                                  new InternetAddress(to));



              // Set Subject: header field

              message.setSubject(subject);



              // Now set the actual message

              StringBuilder text1 = new StringBuilder();

              text1.append("Reunião "+meetingName+" foi criada com sucesso!\n\n");

              text1.append("Convide outras pessoas usando o seguinte link (mostrado abaixo): \n");

              text1.append(inviteURL);

              text1.append("\n\n");

              text1.append("Clique no link abaixo para iniciar a sua reunião: \n");

              text1.append(joinURL);

         

              message.setText(text1.toString());

         

    	      // Or send using an html

    	      // Send the actual HTML message, as big as you like

              // message.setContent("<h1>This is actual message</h1>", "text/html" );



              // Send message

              Transport.send(message);        



              // Now set the actual message

              StringBuilder text2 = new StringBuilder();

              text2.append("Reunião "+meetingName+" foi criada com sucesso!\n\n");

              text2.append("Clique no link abaixo para iniciar a sua reunião: \n");

              text2.append(inviteURL);



              message.setText(text2.toString());



              Transport.send(message);

         

              System.out.println("Sent message successfully....");



          } catch (MessagingException mex) {

              mex.printStackTrace();

          }



	} catch (Exception e) {

     	e.printStackTrace();

	}

	%>



<%@ include file="footer.jsp"%>



<%}else{

	response.sendRedirect("step1.jsp?auth=false");

}

%>
