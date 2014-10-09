<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>

<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>

<%@ page import="org.apache.commons.codec.binary.Base64"%>

<div class="container">

<%

	if (request.getParameterMap().isEmpty()) {
		response.sendRedirect("step1.jsp");
	}
		
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String meetingID = request.getParameter("meetingId");

	if(true) {
		///* com.globo.auth.Autentica.AuthAPICheck(user, pass,false, "10.2.4.45", "BigBlueButton") */
		// This is the URL for to join the meeting as moderator
		//
		String joinURL = getJoinURL(username, meetingID, "false", "<br>Bem-vindo ao %%CONFNAME%%.<br>", null, null);

		String url = BigBlueButtonURL.replace("bigbluebutton/","meeting/");
			
		//meetingID = URLEncoder.encode(meetingID, "UTF-8");
	
		// Get bytes from string
		byte[] byteArray = Base64.encodeBase64(meetingID.getBytes());
	
		// Print the encoded string
		String encodedString = new String(byteArray);
	
		String inviteURL = url + "step3.jsp?meetingID=" + encodedString;
%>
	<h2 class="form-signin-heading">Reunião '<%=meetingID%>' foi criada com sucesso!</h2>

	<br />

	<div class="page-header">
		<h3>Passo 2 - Convide outras pessoas usando o seguinte link (mostrado abaixo):</h3>
		<p class="lead">
			<%=inviteURL%>
		</p>
	</div>

	<div class="page-header">
		<h3>Passo 3 - Clique no link abaixo para iniciar a sua reunião:</h3>
		<p class="lead">
			<a href="<%=joinURL%>">Iniciar reunião</a>
		</p>
	</div>
	<%
	  // Recipient's email ID needs to be mentioned.
      String to = "ribeirao@gmail.com";

      // Sender's email ID needs to be mentioned
      String from = "thirosan@gmail.com";

      // Assuming you are sending email from localhost
      String host = "localhost";

      // Get system properties
      Properties properties = System.getProperties();

      // Setup mail server
      properties.setProperty("smtp.gmail.com", host);

      // Get the default Session object.
      Session session = Session.getDefaultInstance(properties);

      try{
         // Create a default MimeMessage object.
         MimeMessage message = new MimeMessage(session);

         // Set From: header field of the header.
         message.setFrom(new InternetAddress(from));

         // Set To: header field of the header.
         message.addRecipient(Message.RecipientType.TO,
                                  new InternetAddress(to));

         // Set Subject: header field
         message.setSubject("Reunião criada");

         // Now set the actual message
         StringBuilder text = new StringBuilder();
         text.append("Reunião "+meetingID+" foi criada com sucesso!\n\n");
         text.append("Convide outras pessoas usando o seguinte link (mostrado abaixo): \n");
         text.append(inviteURL);
         text.append("\n\n");
         text.append("Clique no link abaixo para iniciar a sua reunião: \n");
         text.append(joinURL);
         
         message.setText(text.toString());

         // Send message
         Transport.send(message);
         System.out.println("Sent message successfully....");
      }catch (MessagingException mex) {
         mex.printStackTrace();
      }
	%>
	
	<%@ include file="footer.jsp"%>

<% }else{ %>
	response.sendRedirect("step1.jsp?auth=false");
<% } %>

