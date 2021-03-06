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
	String viewType = request.getParameter("viewType");
	
	Boolean isAuthenticate = false;
	if(enableAuthAPI){
		isAuthenticate = Autentica.AuthAPICheck(username, password, enableTwoFactor, hostApi, infoApi);
	}else{
		isAuthenticate = true;
	}
	
	if(isAuthenticate){
		String isRecord = "false";

		//Generate Random Meeting Id
	    String meetingId = String.valueOf(UUID.randomUUID());
		String userId = "";
		String authToken = "";
		String encodedMeetingName = URLEncoder.encode(meetingName, "UTF-8");

		// This is the URL for to join the meeting as moderator	
		String url_to_redirect = getJoinURL(username, meetingId, encodedMeetingName, isRecord, "<br>Bem-vindo ao %%CONFNAME%%.<br>", null, null);

		//mount URL for HTML5
		if(viewType.equals("html5")){

			String joinUrlHtml5 = getJoinURLViewerHtml5(username, meetingId);

			//System.out.println(joinUrlHtml5);

			Document doc = parseXml(getURL(joinUrlHtml5));

			
			
			String meetingId2 = doc.getElementsByTagName("meeting_id").item(0).getTextContent();
			userId = doc.getElementsByTagName("user_id").item(0).getTextContent();
			authToken = doc.getElementsByTagName("auth_token").item(0).getTextContent();

			String ip = BigBlueButtonURL.split("\\/bigbluebutton")[0];
			String html5url = ip + "/html5client/" + meetingId2 + "/" + userId + "/" + authToken;


			url_to_redirect = html5url;
	  	}

		String urlParameters = String.format("step3.jsp?meetingID=%s&meetingName=%s&userId=%s&authToken=%s", meetingId, encodedMeetingName, userId, authToken);

		String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
		String inviteURL = url + urlParameters;
%>
	<h2 class="form-signin-heading">Reuni&atilde;o '<%=StringEscapeUtils.escapeHtml(meetingName)%>' foi criada com sucesso!</h2>
	<br />
	<div class="page-header">
		<h3>Passo 2 - Convide outras pessoas usando o seguinte link (mostrado abaixo):</h3>
		<p class="lead"><%=StringEscapeUtils.escapeHtml(inviteURL)%></p>
	</div>
	<div class="page-header">
		<h3>Passo 3 - Clique no link abaixo para iniciar a sua reuni&atilde;o:</h3>
		<p class="lead">
			<a href="<%=StringEscapeUtils.escapeHtml(url_to_redirect)%>">Iniciar reuni&atilde;o</a>
		</p>
	</div>
	
<%
	if(enableMailSend){
	
		String to = "avner.goncalves@s2it.com.br";
		if(enableAuthAPI){
			String resBody = Autentica.responseBody;
        	JSONObject jsonObj = new JSONObject(resBody);
            to = jsonObj.getJSONArray("mail").getString(0);
		}
        
	        	
		// Get system properties
		Properties properties = System.getProperties();
		Session s = Session.getInstance(properties);

		// Using SSL 
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.port", port);
		properties.put("mail.smtp.auth", "false");

		if(enableMailAuth){

			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.socketFactory.port", port);
			properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	
			s = Session.getInstance(properties, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(user, pass);
				}
			});
			
		}
	
		// Create a default MimeMessage object.
		MimeMessage message = new MimeMessage(s);
      	// Set From: header field of the header.
      	message.setFrom(new InternetAddress(from));
      	// Set To: header field of the header.
      	message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
      	// Set Subject: header field
      	message.setSubject(subject);
      
      	// Now set the actual message
      	StringBuilder text1 = new StringBuilder();
      	text1.append("Reunião "+meetingName+" foi criada com sucesso!\n\n");
      	text1.append("Convide outras pessoas usando o seguinte link (mostrado abaixo): \n");
      	text1.append(inviteURL);
      	text1.append("\n\n");
      	text1.append("Clique no link abaixo para iniciar a sua reunião: \n");
      	text1.append(url_to_redirect);

      	message.setText(text1.toString());
      	Transport.send(message);     
      
      	// Now set the actual message
      	StringBuilder text2 = new StringBuilder();
      	text2.append("Reunião "+meetingName+" foi criada com sucesso!\n\n");
      	text2.append("Clique no link abaixo para iniciar a sua reunião: \n");
      	text2.append(inviteURL);

		message.setText(text2.toString());
      	Transport.send(message);
      
      	System.out.println("Sent message successfully....");
	}
%>

<%@ include file="footer.jsp"%>

<%
    	}else{
		response.sendRedirect("step1.jsp?auth=false");
	}
%>
