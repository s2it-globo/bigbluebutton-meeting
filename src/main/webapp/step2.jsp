<%@ include file="header.jsp"%>

<%@ page import="java.util.regex.*"%>
<%@ page import="org.apache.commons.codec.binary.Base64"%>

<div class="container">

<%

	if (request.getParameterMap().isEmpty()) {
		response.sendRedirect("step1.jsp");
	}
		
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String meetingID = request.getParameter("meetingId");
	
	if(!com.globo.sec.authapi.Functions.AuthAPICheck(username, password, false, "10.2.4.45", "BigBlueButton")) {
		response.sendRedirect("step1.jsp?auth=false");
	}
	
	//
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

<%@ include file="footer.jsp"%>